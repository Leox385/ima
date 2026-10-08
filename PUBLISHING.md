# Publishing on GitHub

## Upload to Leox385/ima

1. Extract AstraUI_Public_4.0.0.zip. Upload the extracted files, not just the archive.
2. Sign in and open https://github.com/Leox385/ima .
3. Choose Add file → Upload files.
4. Upload the extracted contents with their folder structure. UI and README.md must be in the repository root. UI has no extension to preserve the existing URL.
5. Use a commit message such as `Publish Astra UI 4.0 English documentation`. Create a branch and pull request to review before merging into main. A direct main commit, where permitted, updates the shared URL immediately.
6. Confirm that the published UI contains Version = "4.0.0".

Do not put everything inside another top-level folder. Replace the previous UI file. Include `.github/workflows/ui-tests.yml` if you want automated simulated tests.

## Shared loader

After publication, load.lua downloads:

```text
https://raw.githubusercontent.com/Leox385/ima/refs/heads/main/UI
```

It verifies the version and exposes the library. Use tutorial.lua to create the showcase. Until this version is published, the URL may deliver the previous library. For a reproducible release, replace refs/heads/main with the actual published commit SHA.

## Release checks

Run the standalone tutorial, then the remote loader, in Matcha. Verify opening, controls, closing and reloading on another PC. Record the Matcha versions actually tested. Choose a license describing how others may reuse your work; a license has not been selected on your behalf.

[Official GitHub upload guide](https://docs.github.com/en/repositories/working-with-files/managing-files/adding-a-file-to-a-repository?platform=windows)
