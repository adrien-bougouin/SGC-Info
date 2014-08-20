################################################################################
# Makefile
#
# Adrien Bougouin <adrien.bougouin@gmail.com>
################################################################################

CC			= clang
LD			= $(CC)
CFLAGS	= -Wall -pedantic -ansi -std=c99
LDFLAGS	= -framework Foundation -framework AppKit

exec_NAME				= sgc_info
project_NAME		= SGC-Info
project_VERSION	= 1.1
dist_NAME				= $(project_NAME).app
image_VOLUME		= $(project_NAME)-$(project_VERSION)
image_NAME			= $(image_VOLUME).dmg

source_DIR		= src
resource_DIR	= resources
build_DIR			= build
obj_DIR				= $(build_DIR)/.obj
info_PLIST		= info.plist
sed_CMD				= -e 's/exec_NAME/$(exec_NAME)/g' \
								-e 's/dist_NAME/$(project_NAME)/g' \
								-e 's/project_VERSION/$(project_VERSION)/g'

################################################################################

default: init dist

all: init dmg

init:
	@mkdir -p $(build_DIR)
	@mkdir -p $(obj_DIR)

dmg: $(build_DIR)/$(image_NAME)

$(build_DIR)/$(image_NAME): $(build_DIR)/$(dist_NAME)
	@echo ">> Creating the install disk"
	@hdiutil create -fs HFS+ -srcfolder $< -volname $(image_VOLUME) $@

dist: $(build_DIR)/$(dist_NAME)

$(build_DIR)/$(dist_NAME): $(build_DIR)/$(exec_NAME) $(info_PLIST)
	@echo ">> Creating $(dist_NAME)"
	@mkdir -p $@/Contents/MacOS
	@cp -R $(resource_DIR) $@/Contents/Resources
	@sed $(sed_CMD) $(info_PLIST) > $@/Contents/Info.plist
	@echo "APPL????" > $@/Contents/PkgInfo
	@cp $< $@/Contents/MacOS

$(build_DIR)/$(exec_NAME): $(obj_DIR)/main.o $(obj_DIR)/AppController.o \
													 $(obj_DIR)/BundleBar.o $(obj_DIR)/AboutBundleView.o \
													 $(obj_DIR)/GenesisCartridgeController.o \
													 $(obj_DIR)/GenesisCartridgeView.o
	@echo ">> Compiling $(exec_NAME)"
	@$(LD) -o $@ $^ $(LDFLAGS)

$(obj_DIR)/main.o: $(source_DIR)/main.m $(source_DIR)/AppController.h
	@echo ">> $<\n   |-> $@"
	@$(CC) -o $@ -c $< $(CFLAGS)

$(obj_DIR)/AppController.o: $(source_DIR)/AppController.m \
														$(source_DIR)/AppController.h \
														$(source_DIR)/BundleBar.h \
														$(source_DIR)/AboutBundleView.h \
														$(source_DIR)/GenesisCartridgeController.h \
														$(source_DIR)/GenesisCartridgeView.h
	@echo ">> $<\n   |-> $@"
	@$(CC) -o $@ -c $< $(CFLAGS)

$(obj_DIR)/BundleBar.o: $(source_DIR)/BundleBar.m $(source_DIR)/BundleBar.h
	@echo ">> $<\n   |-> $@"
	@$(CC) -o $@ -c $< $(CFLAGS)

$(obj_DIR)/AboutBundleView.o: $(source_DIR)/AboutBundleView.m \
															$(source_DIR)/AboutBundleView.h
	@echo ">> $<\n   |-> $@"
	@$(CC) -o $@ -c $< $(CFLAGS)

$(obj_DIR)/GenesisCartridgeController.o: $(source_DIR)/GenesisCartridgeController.m \
															 					 $(source_DIR)/GenesisCartridgeController.h
	@echo ">> $<\n   |-> $@"
	@$(CC) -o $@ -c $< $(CFLAGS)

$(obj_DIR)/GenesisCartridgeView.o: $(source_DIR)/GenesisCartridgeView.m \
															 		 $(source_DIR)/GenesisCartridgeView.h \
															 		 $(source_DIR)/GenesisCartridgeController.h
	@echo ">> $<\n   |-> $@"
	@$(CC) -o $@ -c $< $(CFLAGS)

################################################################################

.PHONY: clean cleandist mrproper

clean:
	rm -rf $(obj_DIR)

cleandist:
	rm -rf $(build_DIR)/$(dist_NAME)

mrproper:
	rm -rf $(build_DIR)

