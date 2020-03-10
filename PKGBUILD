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
sha512sums=('a9af1a85dc0adde7cffdb3544ca6b4e18ce129683f5bfdcdfda9c954d759f909c05e1716b9beda50f4f15104047cdae18f25897090baf7118c35f7d0b5c82cfd'
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
