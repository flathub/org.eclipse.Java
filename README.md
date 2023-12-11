This the Flatpak version of [Eclipse IDE](https://www.eclipse.org/ide/).

## Build

To build locally run
```
flatpak-builder build-dir --force-clean org.eclipse.Java.json
```

Test the installation using
```
flatpak-builder --user --install --force-clean build-dir org.eclipse.Java.json
```

## Run
```
flatpak run org.eclipse.Java
```

## Install

To install a stable release version from the repository use the following:
```
flatpak remote-add flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.eclipse.Java.json
```

