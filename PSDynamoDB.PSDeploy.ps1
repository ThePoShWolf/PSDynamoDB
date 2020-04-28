Deploy "PSDynamoDB" {
    By PSGalleryModule {
        FromSource "Build\PSDynamoDB"
        To PSGallery
        WithOptions @{
            ApiKey = ''
        }
    }
}