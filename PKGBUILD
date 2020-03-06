# Maintainer: Knut Ahlers <knut at ahlers dot me>

pkgname=arch-update
pkgver=r4.37d56f8
pkgrel=1
pkgdesc="Execute (automatic) updates with service / machine restarts"
arch=('any')
url="https://gist.github.com/Luzifer/493cea96052493ed70d4cdd572db32f0"
license=(Apache)
depends=(pacman-contrib)
source=(
	arch_update.sh
	arch-update.service
	arch-update.timer
)
sha512sums=('609794ba2c80e70f7b32fc5323e0897d643a836af2899916c72d5727a0afd8b41341d8ab7d4b9fa7a06c10a9803a34a9bb380c92f15276e2dc459652b6b464d3'
            '384a9fc9c7f43bd7e9ec9274b5e930e7e9e3dcea088f524201f0b359f33e470b9b120b6c261b82b2d484d7af937eb67ba2cdf7a0bda2ca424338da03e008a716'
            'f9b62fbc31d963525340c408ddacf671c54d9874b4decd1c84286b2a000ef488a85d738f7a3d83db34e9dd98baa84389aff837bdf68531712ba9eaa7a8d762bd')

package() {
	install -Dm755 "${srcdir}/arch_update.sh" "${pkgdir}/usr/bin/arch_update"
	install -Dm755 "${srcdir}/arch-update.service" "${pkgdir}/usr/lib/systemd/system/arch-update.service"
	install -Dm755 "${srcdir}/arch-update.timer" "${pkgdir}/usr/lib/systemd/system/arch-update.timer"
}

pkgver() {
	echo "r$(git rev-list --count HEAD).$(git rev-parse --short HEAD)"
}
