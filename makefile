include config.mk

# 打包目录
PACK_DIR = pack
# 工作空间
WORKSPACE = /opt/$(PACKAGE)
# 可执行文件安装目录
BIN_DIR = /usr/bin
# 配置文件
CONF_DIR = /etc/mediamtx
# 服务文件
SERVICE_DIR = /lib/systemd/system

all:
	@mkdir -p $(PACK_DIR)$(BIN_DIR)
	@mkdir -p $(PACK_DIR)$(CONF_DIR)
	@mkdir -p $(PACK_DIR)$(SERVICE_DIR)
	@cp bin/$(TARGET) $(PACK_DIR)$(BIN_DIR)
	@cp config/$(TARGET).yml $(PACK_DIR)$(CONF_DIR)
	@cp service/$(SERVICE) $(PACK_DIR)$(SERVICE_DIR)
	@mkdir -p $(PACK_DIR)/DEBIAN
	@echo "Package: $(PACKAGE)" > $(PACK_DIR)/DEBIAN/control
	@echo "Version: $(VERSION)$(VERSION_SUFFIX)" >> $(PACK_DIR)/DEBIAN/control
	@echo "Section: $(SECTION)" >> $(PACK_DIR)/DEBIAN/control
	@echo "Priority: $(PRIORITY)" >> $(PACK_DIR)/DEBIAN/control
	@echo "Architecture: $(ARCHITECTURE)" >> $(PACK_DIR)/DEBIAN/control
	@echo "Depends: $(DEPENDS)" >> $(PACK_DIR)/DEBIAN/control
	@echo "Maintainer: $(MAINTAINER)" >> $(PACK_DIR)/DEBIAN/control
	@echo "Description: $(DESCRIPTION)" >> $(PACK_DIR)/DEBIAN/control
	@echo "#!/bin/bash" > $(PACK_DIR)/DEBIAN/postinst
	@echo "set -e" >> $(PACK_DIR)/DEBIAN/postinst
	@echo "systemctl daemon-reload" >> $(PACK_DIR)/DEBIAN/postinst
	@echo "systemctl disable $(SERVICE)" >> $(PACK_DIR)/DEBIAN/postinst
	@echo "systemctl enable $(SERVICE)" >> $(PACK_DIR)/DEBIAN/postinst
	@echo "exit 0" >> $(PACK_DIR)/DEBIAN/postinst
	@chmod 755 $(PACK_DIR)/DEBIAN/postinst
	fakeroot dpkg-deb --build $(PACK_DIR) $(PACKAGE)_$(VERSION)_$(ARCHITECTURE).deb
	@rm -rf $(PACK_DIR)

.PHONY: all
