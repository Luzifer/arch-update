# Maintainer: Knut Ahlers <knut at ahlers dot me>

pkgname=arch-update
pkgver=r4.37d56f8
pkgrel=1
pkgdesc="Execute (automatic) updates with service / machine restarts"
arch=('any')
url="https://gist.github.com/Luzifer/493cea96052493ed70d4cdd572db32f0"
license=(Apache)
depends=(pacman-contrib)
source=(arch_update.sh)
sha512sums=('609794ba2c80e70f7b32fc5323e0897d643a836af2899916c72d5727a0afd8b41341d8ab7d4b9fa7a06c10a9803a34a9bb380c92f15276e2dc459652b6b464d3')

package() {
	install -Dm755 "${srcdir}/arch_update.sh" "${pkgdir}/usr/bin/arch_update"
}

pkgver() {
	echo "r$(git rev-list --count HEAD).$(git rev-parse --short HEAD)"
}
