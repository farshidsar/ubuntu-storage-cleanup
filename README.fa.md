# Ubuntu Storage Cleanup

یک ابزار Bash کاربردی برای آزاد کردن فضای دیسک در Ubuntu با پاک‌سازی کش APT، لاگ‌های systemd، لاگ‌های rotate شده، فایل‌های موقت قدیمی، نسخه‌های غیرفعال Snap، منابع بلااستفاده Docker، crash dumpها و thumbnail cache کاربران.

**نویسنده:** فرشید  
**License:** MIT

> ⭐ اگر این پروژه برات مفید بود، لطفاً به Repository یک **Star** بده. هم باعث می‌شه پروژه بیشتر دیده بشه، هم به من برای ادامه توسعه و بهتر کردنش انگیزه می‌ده.

## زبان‌ها

- [English](README.md)
- فارسی — همین فایل
- [العربية](README.ar.md)
- [Русский](README.ru.md)

## قابلیت‌ها

- نمایش فضای دیسک قبل و بعد از پاک‌سازی
- پاک‌سازی کش APT
- حذف پکیج‌های بلااستفاده
- پاک‌سازی journalهای قدیمی systemd
- حذف لاگ‌های rotate و فشرده‌شده
- حذف فایل‌های موقت قدیمی‌تر از ۷ روز
- حذف revisionهای غیرفعال Snap
- پاک‌سازی اختیاری Docker با تأیید کاربر
- حفظ Docker volumes
- حذف crash dumpهای قدیمی
- پاک‌سازی thumbnail cache کاربران
- نمایش بزرگ‌ترین دایرکتوری‌های سطح اول سیستم

## پیش‌نیازها

- Ubuntu یا یک توزیع سازگار مبتنی بر Debian
- Bash
- دسترسی `sudo` یا root
- `systemd` برای پاک‌سازی journal
- Snap اختیاری است
- Docker اختیاری است

## نصب

Repository را clone کن:

```bash
git clone https://github.com/YOUR_USERNAME/ubuntu-storage-cleanup.git
cd ubuntu-storage-cleanup
```

بعد فایل اسکریپت را executable کن:

```bash
chmod +x ubuntu-storage-cleanup.sh
```

## نحوه اجرا

روش پیشنهادی:

```bash
sudo ./ubuntu-storage-cleanup.sh
```

یا می‌توانی مستقیم با Bash اجرا کنی:

```bash
sudo bash ubuntu-storage-cleanup.sh
```

اسکریپت بدون دسترسی root اجرا نمی‌شود.

## پاک‌سازی Docker

اگر Docker نصب باشد، ابتدا مقدار فضای مصرفی Docker نمایش داده می‌شود و بعد اسکریپت می‌پرسد:

```text
Clean Docker unused resources? (y/N):
```

فقط اگر `y` یا `Y` وارد کنی، پاک‌سازی Docker انجام می‌شود.

دستورهای مورد استفاده:

```bash
docker system prune -af
docker builder prune -af
```

این دستورات ممکن است imageهای بلااستفاده، containerهای متوقف‌شده، networkهای بلااستفاده و build cache را حذف کنند. **Docker volumes حذف نمی‌شوند.**

## تنظیمات

در ابتدای اسکریپت این مقادیر قابل تغییر هستند:

```bash
JOURNAL_RETENTION="7d"
JOURNAL_MAX_SIZE="200M"
MIN_FREE_GB=5
```

`JOURNAL_RETENTION` مدت نگه‌داری journalها و `JOURNAL_MAX_SIZE` سقف هدف برای vacuum کردن journalها را مشخص می‌کند.

> توجه: متغیر `MIN_FREE_GB` در حال حاضر تعریف شده، اما هنوز در منطق پاک‌سازی استفاده نمی‌شود.

## هشدار مهم

این اسکریپت عملیات حذف فایل انجام می‌دهد. قبل از استفاده روی سرور production یا سیستمی که اطلاعات مهم دارد، خود اسکریپت را بررسی کن.

اسکریپت از مسیرهایی مثل موارد زیر فایل حذف می‌کند:

```text
/var/log
/tmp
/var/tmp
/var/crash
/home/*/.cache/thumbnails
/var/cache/debconf
```

همچنین فایل‌های خالی داخل `/var/log` حذف می‌شوند؛ اگر سرویسی داری که به فایل لاگ خالیِ از قبل ساخته‌شده وابسته است، این بخش را قبل از اجرا بررسی کن.

## اجرای سریع بعد از Clone

```bash
cd ubuntu-storage-cleanup
chmod +x ubuntu-storage-cleanup.sh
sudo ./ubuntu-storage-cleanup.sh
```

## ساختار پروژه

```text
ubuntu-storage-cleanup/
├── ubuntu-storage-cleanup.sh
├── README.md
├── README.fa.md
├── README.ar.md
├── README.ru.md
└── LICENSE
```

## مشارکت

Issue، پیشنهاد و Pull Request خوشحال‌کننده است. اگر ایده‌ای برای امن‌تر، سریع‌تر، قابل تنظیم‌تر یا سازگارتر شدن اسکریپت داری، می‌تونی مطرحش کنی.

## حمایت از پروژه ⭐

اگر اسکریپت برات مفید بود یا کمک کرد فضای دیسک آزاد کنی، لطفاً به پروژه یک **Star ⭐** بده.

Star شما باعث می‌شه افراد بیشتری پروژه را پیدا کنند و برای ادامه توسعه، رفع باگ‌ها و اضافه کردن قابلیت‌های جدید به من انگیزه می‌ده.

## License

این پروژه با [MIT License](LICENSE) منتشر شده است.

Copyright © 2026 فرشید
