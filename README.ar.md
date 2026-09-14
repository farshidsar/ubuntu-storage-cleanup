# Ubuntu Storage Cleanup

أداة Bash عملية لتحرير مساحة التخزين في Ubuntu عبر تنظيف ذاكرة APT المؤقتة، وسجلات systemd، والسجلات القديمة، والملفات المؤقتة، وإصدارات Snap المعطلة، وموارد Docker غير المستخدمة، وملفات crash dump، وذاكرة الصور المصغرة.

**المؤلف:** فرشید  
**الترخيص:** MIT

> ⭐ إذا كان المشروع مفيدًا لك، فلا تنسَ إعطاء المستودع **Star**. هذا يساعد الآخرين على اكتشاف المشروع ويمنحني دافعًا للاستمرار في تطويره وتحسينه.

## اللغات

- [English](README.md)
- [فارسی](README.fa.md)
- العربية — هذا الملف
- [Русский](README.ru.md)

## المميزات

- عرض استخدام القرص قبل التنظيف وبعده
- تنظيف ذاكرة APT المؤقتة
- إزالة حزم APT غير المستخدمة
- تنظيف سجلات systemd journal القديمة
- حذف السجلات القديمة والمضغوطة
- حذف الملفات المؤقتة الأقدم من 7 أيام
- حذف إصدارات Snap المعطلة
- تنظيف Docker اختياريًا بعد تأكيد المستخدم
- الحفاظ على Docker volumes
- حذف crash dumps القديمة
- تنظيف thumbnail cache للمستخدمين
- عرض أكبر المجلدات بعد انتهاء التنظيف

## المتطلبات

- Ubuntu أو توزيعة متوافقة مبنية على Debian
- Bash
- صلاحيات `sudo` أو root
- `systemd` لتنظيف journal
- Snap اختياري
- Docker اختياري

## التثبيت

استنسخ المستودع:

```bash
git clone https://github.com/YOUR_USERNAME/ubuntu-storage-cleanup.git
cd ubuntu-storage-cleanup
```

ثم اجعل السكربت قابلًا للتنفيذ:

```bash
chmod +x ubuntu-storage-cleanup.sh
```

## طريقة التشغيل

الطريقة المقترحة:

```bash
sudo ./ubuntu-storage-cleanup.sh
```

أو شغّله مباشرة عبر Bash:

```bash
sudo bash ubuntu-storage-cleanup.sh
```

لن يعمل السكربت بدون صلاحيات root.

## تنظيف Docker

إذا كان Docker مثبتًا، يعرض السكربت أولًا استخدام مساحة Docker ثم يسأل:

```text
Clean Docker unused resources? (y/N):
```

لن يتم تنظيف Docker إلا إذا أدخلت `y` أو `Y`.

الأوامر المستخدمة:

```bash
docker system prune -af
docker builder prune -af
```

قد تؤدي هذه الأوامر إلى حذف الصور غير المستخدمة والحاويات المتوقفة والشبكات غير المستخدمة وbuild cache. **لن يتم حذف Docker volumes.**

## الإعدادات

يمكن تعديل القيم التالية في بداية السكربت:

```bash
JOURNAL_RETENTION="7d"
JOURNAL_MAX_SIZE="200M"
MIN_FREE_GB=5
```

> ملاحظة: المتغير `MIN_FREE_GB` موجود حاليًا، لكنه لا يُستخدم بعد في منطق التنظيف.

## تحذير مهم

السكربت يقوم بحذف ملفات. راجعه قبل استخدامه على خوادم production أو على أنظمة تحتوي على بيانات مهمة.

يمكن أن يحذف ملفات من مسارات مثل:

```text
/var/log
/tmp
/var/tmp
/var/crash
/home/*/.cache/thumbnails
/var/cache/debconf
```

كما يحذف الملفات الفارغة داخل `/var/log`، لذلك راجع هذا السلوك إذا كانت بعض خدماتك تعتمد على ملفات سجل فارغة تم إنشاؤها مسبقًا.

## تشغيل سريع بعد Clone

```bash
cd ubuntu-storage-cleanup
chmod +x ubuntu-storage-cleanup.sh
sudo ./ubuntu-storage-cleanup.sh
```

## هيكل المشروع

```text
ubuntu-storage-cleanup/
├── ubuntu-storage-cleanup.sh
├── README.md
├── README.fa.md
├── README.ar.md
├── README.ru.md
└── LICENSE
```

## المساهمة

نرحب بالـ Issues والاقتراحات وPull Requests، خصوصًا التحسينات المتعلقة بالأمان والتوافق والتقارير والإعدادات.

## ادعم المشروع ⭐

إذا وفر لك السكربت وقتًا أو مساحة تخزين، أعطِ المشروع **Star ⭐**.

الـ Star يساعد الآخرين على اكتشاف المشروع ويمنحني دافعًا للاستمرار في إصلاح المشاكل وإضافة ميزات جديدة.

## الترخيص

المشروع منشور تحت [MIT License](LICENSE).

Copyright © 2026 فرشید
