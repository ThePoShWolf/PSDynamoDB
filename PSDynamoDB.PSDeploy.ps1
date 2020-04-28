Deploy "$($MyInvocation.MyCommand.Name.Split('.')[0])" {
    By PSGalleryModule {
        FromSource "Build\$($MyInvocation.MyCommand.Name.Split('.')[0])"
        To PSGallery
        WithOptions @{
            ApiKey = ''
        }
    }
}