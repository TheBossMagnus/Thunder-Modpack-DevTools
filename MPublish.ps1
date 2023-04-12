$version = (Get-ChildItem -Path "C:\Users\tbmag\GitHub\Quilt-Optimized\bin" -Directory | Sort-Object LastWriteTime)[-1].Name   #getv latest version

#contains the list of all the supported editions
$editions = @(
    #"fabric/1.16.5""fabric/1.17.2""fabric/1.18.2", "fabric/1.19.2", "fabric/1.19.3", "fabric/1.19.4"
    "quilt/1.18.2", "quilt/1.19.2", "quilt/1.19.3", "quilt/1.19.4"
    )

gh release create $version -t $version -d -R TheBossMagnus/Quilt-Optimized

foreach ($edition in $editions) {


    $loader =  $edition.split("/")[0]   #get modloader
    $MCversion =  $edition.split("/")[1]    #get MC version

    gh release upload $version "C:\Users\tbmag\GitHub\Quilt-Optimized\bin\$version\$loader\Quilt Optimized-$version for $loader $MCversion.mrpack"
}
Pause