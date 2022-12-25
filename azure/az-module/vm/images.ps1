
# How to get images? ImagePublisher - ImageOffer - ImageSku - Image (Version)
$publisher = (Get-AzVMImagePublisher -Location francecentral | Where-Object PublisherName -like 'Canonical').PublisherName
$imageOffer = (Get-AzVMImageOffer -Location francecentral -PublisherName $publisher | Where-Object Offer -match '.*minimal-jammy$').Offer
$sku = (Get-AzVMImageSku -Location francecentral -PublisherName $publisher -Offer $imageOffer | Where-Object Skus -like '*lts-gen2').Skus
$version = (Get-AzVMImage -Location francecentral -PublisherName $publisher -Offer $imageOffer -Sku $sku | Sort-Object -Descending -Property Version | Select-Object -First 1).Version

Write-Host "Version of the image for the publisher: $publisher, imageOffer: $imageOffer, sku: $sku -> $version" -ForegroundColor Green
Write-Host "Image -> $publisher`:$imageOffer`:$sku`:$version" -ForegroundColor Green
