# Learning MPMedia

Về cơ bản thì thư viện này giúp ta lâý được URL bài hát trong Apple Music, sau khi có URL của các bài hát, ta có thể play nhạc, next nhạc,... Chú ý rằng, ta chỉ có thể lấy URL của bài hát trong Apple Music, chứ không thể explore ra data trong FileManager. Hmm nhưng cũng đ hiểu sao, khi merge video với audio thì merge được.

Sau đây là các bước để có thể lấy được URL của các bài hát từ Apple Music.

## I. Music Library Authorization

Để có thể lấy được URL bài hát, ta cần request authorization của user bằng cách add dòng này vào info.plist:
- `Privacy — Media Library Usage Description” key(NSAppleMusicUsageDescription)`

Sau khi add xong, ta sẽ gửi hàm request:

```php
func requestAuthorzation() {
    MPMediaLibrary.requestAuthorization { status in
        switch status {
        case .notDetermined:
            DispatchQueue.main.async {
                let url = URL(string:UIApplication.openSettingsURLString)!
                UIApplication.shared.open(url)
            }
        case .denied:
            DispatchQueue.main.async {
                let url = URL(string:UIApplication.openSettingsURLString)!
                UIApplication.shared.open(url)
            }
        case .restricted:
            break
        case .authorized:
            DispatchQueue.main.async {
                print("Siuuuuuu")
            }
    }
}
```

Method `requestAuthorization()` sẽ được request trên background Thread, do đó sau khi request completion complete, ta phải update data trên main Thread.

```php
DispatchQueue.main.async {
    let url = URL(string:UIApplication.openSettingsURLString)!
    UIApplication.shared.open(url)
}
```
Đoạn code này sẽ mở setting của user lên luôn.

## 2. Exploring the Music Library

Sau khi đã request Authorzation, ta sẽ tiến hành get song(bài hát), và từ song đó, ta sẽ lấy các Propeties của song đó như name, artist....

Mọi thứ trong music'library, được gọi là `MPMediaEntity` trong code. Nó có 2 subclasses quan trọng sau:
- `MPMediaItem:` Đại diện cho 1 song
- `MPMediaItemCollection:`  Đại diện cho 1 list mã đã được sắp xếp của các `MPMediaItem`. Nó có thuộc tính `items` sẽ chứa 1 array các `MPMediaItem`.

Để có thể fetch được các property của 1 instance `MPMediaItem`, ta có thể sử dụng KVC như sau:
```php
// Fetch only one property at a time.
func value(forProperty property: String) -> Any?

// In some cases, enumerating the values for multiple properties can be more efficient than fetching each individual property with -valueForProperty:.
func enumerateValues(forProperties properties: Set<String>, using block: @escaping (String, Any, UnsafeMutablePointer<ObjCBool>) -> Void)
```

VD: Để có thể truy cập vào `title` property của `MediaItem` thì ta có 2 cách:
```php
let mediaItem = MPMediaItem()
mediaItem.value(forProperty: MPMediaItemPropertyArtist)  ///Cách 1
mediaItem.artist                                        /// Cách 2
```

## 3. Querying the Music Library

Ở phần 2, ta đã biết cách access các property của 1 bài hát. Giờ ở phần này, ta sẽ tiến hành get bài hát đó :). Để có thể get song, ta sẽ sử dụng query.

Có 2 cách để tạo 1 query

- Cách 1:

```php
let query: MPMediaQuery = MPMediaQuery()
```

Khi khởi tạo 1 biến query như này, ta đã lấy được toàn bộ song từ Library, và đéo cần làm gì nữa cả :))) Ngạc nhiên chưa.