# Quick Cocktail - iOS App

Evdeki malzemelerle hızlıca kokteyl tarifleri bulan modern bir iOS uygulaması.

## Özellikler

### Temel Özellikler
- **Malzeme Bazlı Arama**: Evdeki malzemeleri seçerek yapabileceğiniz kokteylleri keşfedin
- **Günün Kokteyli**: Her gün farklı bir kokteyl önerisi
- **Popüler Kokteyller**: En çok tercih edilen kokteyllere hızlı erişim
- **Detaylı Tarifler**: Malzeme listesi, ölçüler ve hazırlama talimatları

### Kişiselleştirme
- **Favoriler**: Beğendiğiniz kokteylleri kaydedin
- **Geçmiş**: Görüntülediğiniz kokteyllere tekrar ulaşın
- **Alışveriş Listesi**: Eksik malzemeleri listeye ekleyin

### Türkiye Pazarı Entegrasyonu
- Malzemeler için Trendyol, Hepsiburada, Migros ve Getir linkleri
- Türkçe arayüz ve talimatlar

### Görsel Tasarım
- Modern ve şık koyu tema (bar ambiyansı)
- Animasyonlu arka plan
- Glassmorphism tasarım dili
- Smooth geçişler ve animasyonlar

## Teknoloji Stack

- **UI Framework**: SwiftUI (iOS 17+)
- **Veri Saklama**: SwiftData
- **Networking**: URLSession + async/await
- **API**: TheCocktailDB (600+ kokteyl)
- **Mimari**: MVVM

## Gereksinimler

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Kurulum

1. Projeyi klonlayın veya indirin
2. `QuickCocktail.xcodeproj` dosyasını Xcode ile açın
3. Bir simulator veya gerçek cihaz seçin
4. Build & Run (⌘ + R)

## Proje Yapısı

```
QuickCocktail/
├── App/
│   ├── QuickCocktailApp.swift
│   └── ContentView.swift
├── Models/
│   ├── Cocktail.swift
│   ├── Ingredient.swift
│   ├── FavoriteCocktail.swift
│   ├── CocktailHistory.swift
│   └── ShoppingList.swift
├── Services/
│   └── CocktailAPIService.swift
├── ViewModels/
│   ├── HomeViewModel.swift
│   ├── SearchViewModel.swift
│   └── CocktailDetailViewModel.swift
├── Views/
│   ├── Home/
│   ├── Search/
│   ├── Detail/
│   ├── Favorites/
│   ├── History/
│   ├── Shopping/
│   └── Components/
└── Resources/
    └── Assets.xcassets
```

## API

Uygulama [TheCocktailDB](https://www.thecocktaildb.com/) ücretsiz API'sini kullanmaktadır.

### Kullanılan Endpointler

| Endpoint | Açıklama |
|----------|----------|
| `/search.php?s=name` | İsme göre arama |
| `/filter.php?i=ingredient` | Malzemeye göre filtreleme |
| `/lookup.php?i=id` | ID ile detay getirme |
| `/random.php` | Rastgele kokteyl |
| `/list.php?i=list` | Tüm malzemeler listesi |

## Ekran Görüntüleri

Uygulama aşağıdaki ana ekranları içerir:
- Ana Sayfa (Günün kokteyli ve popüler kokteyller)
- Malzeme Arama (600+ malzeme)
- Sonuçlar (Grid görünümü)
- Kokteyl Detay (Malzemeler ve talimatlar)
- Favoriler
- Geçmiş
- Alışveriş Listesi

## Lisans

Bu proje eğitim amaçlı geliştirilmiştir.

## Katkıda Bulunma

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/yeni-ozellik`)
3. Değişikliklerinizi commit edin (`git commit -m 'Yeni özellik eklendi'`)
4. Branch'e push yapın (`git push origin feature/yeni-ozellik`)
5. Pull Request açın
