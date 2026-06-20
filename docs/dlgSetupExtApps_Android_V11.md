# dlgSetupExtApps — Tier 2 (future / Android 11+) notes

Context: `LoadAllExtApps` currently lists apps via `getInstalledPackages` + flag
filtering. Tier 1 (done) made it async/yielding, sorted alphabetically, excluded
HomeCentral itself, and fixed the AdaptiveIconDrawable crash (icons now rendered
via Canvas). Tested OK on Android 4.4 and Android 9.

Tier 2 is NOT done — it's a quality/correctness upgrade to consider later.

## What tier 2 changes

Swap enumeration from `getInstalledPackages` + flag-filtering to
**`queryIntentActivities` with `ACTION_MAIN` / `CATEGORY_LAUNCHER`** (the standard
"list launchable apps" query).

1. **Only apps that can actually be launched.**
   The current filter (`Bit.And(flags,1)=0`) returns *non-system packages*, which
   is not the same as *launchable apps*. Some packages are services/libraries with
   no launcher activity — they can appear in the list, the user taps one, and
   nothing launches. `queryIntentActivities` returns only apps that have a launcher
   icon, so every row is guaranteed launchable.

2. **Removes the two fragile heuristics.**
   - The `name_temp.Contains("map")` hack goes away (Maps shows up naturally
     because it has a launcher).
   - The system/non-system flag guess goes away.

3. **Includes launchable *system* apps — the big behavior change.**
   Current code HIDES system apps (Camera, Clock, stock Browser, Settings, etc.)
   except anything with "map" in the name. `queryIntentActivities` includes them.
   For a kitchen hub this is probably desirable (launch the stock Camera/Clock),
   but it changes what appears, so it's a decision.

4. **Future-proofs for Android 11+ (API 30).**
   On API 30+, `getInstalledPackages` returns a RESTRICTED list without
   `QUERY_ALL_PACKAGES` or a `<queries>` manifest entry. Android 9 (API 28) is NOT
   affected — so this hasn't been hit yet. The launcher-intent query is specifically
   allowed on API 30+ with a small `<queries>` manifest block, so tier 2 also makes
   the picker correct on newer tablets.

## What it costs

- A rewrite of the enumeration loop (build an Intent, `queryIntentActivities`,
  iterate `ResolveInfo` → `activityInfo`). More Reflector/JavaObject code than now.
- It also yields the **component name** (package + activity), which is the proper
  way to *launch* an app — so it may improve the launch path in `ExternalAppCtrl` too.

## When to do tier 2

Only worth it if one of these is true:
- You want **launchable system apps** (Camera/Clock/Browser) selectable, not just
  user-installed apps.
- You've seen **list rows that don't launch** when tapped.
- You actually deploy to **Android 11+** tablets.

If none apply, tier 1 is fine and we stop there.
