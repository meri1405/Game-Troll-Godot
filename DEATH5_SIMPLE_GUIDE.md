# 📱 HƯỚNG DẪN POPUP SCENE SAU 5 LẦN CHẾT - ĐƠN GIẢN

## 🎯 **TÍNH NĂNG**
- Sau mỗi 5 lần chết, tự động hiện popup scene
- Có thể thay đổi popup scene dễ dàng
- Lưu trạng thái tự động

---

## 🔧 **CÁCH THAY ĐỔI POPUP SCENE**

### **Vị trí thay đổi:**
📍 **File:** `CommonScripts/Death5PopupManager.gd`  
📍 **Dòng 11:**

```gdscript
var popup_scene_path: String = "res://UI/CustomPopup.tscn"  # ← THAY ĐỔI SCENE TẠI ĐÂY
```

### **Ví dụ thay đổi:**
```gdscript
# Thay đổi scene popup của bạn
var popup_scene_path: String = "res://MyPopups/MyAdScene.tscn"
var popup_scene_path: String = "res://Ads/VideoAd.tscn" 
var popup_scene_path: String = "res://UI/OfferPopup.tscn"
```

---

## 🎮 **CÁCH SỬ DỤNG TRONG CODE**

### **Thay đổi popup scene runtime:**
```gdscript
# Trong bất kỳ script nào:
Death5PopupManager.set_popup_scene_path("res://MyAds/NewAdScene.tscn")
```

### **Debug/Test:**
```gdscript
# Test popup ngay lập tức:
Death5PopupManager.debug_trigger_popup()

# Thêm deaths fake để test:
Death5PopupManager.debug_add_deaths(5)

# Xem trạng thái hiện tại:
Death5PopupManager.debug_show_status()
```

---

## 📝 **YÊU CẦU CHO POPUP SCENE**

Popup scene của bạn nên có:

### **1. Root Node:** Control hoặc Window
### **2. Close Button (Tùy chọn):**
```gdscript
# Trong popup scene script:
signal popup_closed()

func _on_close_button_pressed():
    popup_closed.emit()
    queue_free()
```

### **3. Cấu trúc Scene Đơn Giản:**
```
MyPopupScene.tscn
├── Control (Root)
    ├── Background (ColorRect/TextureRect)
    ├── Content (Labels, Images, etc.)
    └── CloseButton (Button)
```

---

## ⚙️ **SETTINGS**

### **Thay đổi số lượt chết:**
📍 **File:** `CommonScripts/Death5PopupManager.gd`  
📍 **Dòng 5:**
```gdscript
const DEATHS_PER_POPUP = 5  # ← Thay đổi số lượng deaths cần thiết
```

### **Ví dụ:**
```gdscript
const DEATHS_PER_POPUP = 3   # Popup sau 3 lần chết
const DEATHS_PER_POPUP = 10  # Popup sau 10 lần chết
```

---

## 🧪 **TEST & DEBUG**

### **Test trong Godot Console:**
```gdscript
# Force popup ngay:
Death5PopupManager.debug_trigger_popup()

# Thêm 5 deaths fake:
Death5PopupManager.debug_add_deaths(5)

# Reset counter:
Death5PopupManager.reset_death_count()

# Check status:
Death5PopupManager.debug_show_status()
```

---

## 📊 **THÔNG TIN HỆ THỐNG**

- **File save:** `user://death5_popup_data.dat`
- **AutoLoad:** Tự động chạy khi game khởi động
- **Tích hợp:** GameManager tự động gọi khi player chết
- **Độc lập:** Không ảnh hưởng đến daily death limit (50/ngày)

---

## ✅ **HOÀN THÀNH**

Hệ thống đã sẵn sàng sử dụng! 

**Để thay đổi popup scene:** Chỉ cần sửa `popup_scene_path` trong `Death5PopupManager.gd`

**Để test:** Dùng `Death5PopupManager.debug_trigger_popup()` trong console

---

*Đơn giản và dễ sử dụng! 🎉*