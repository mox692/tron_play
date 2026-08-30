project_dir := justfile_directory() + "/mtk3bsp2_samples/IDE_Projects/mtk3bsp2_stm32h723"
project_name := "mtk3bsp2_stm32h723"
workspace := "/tmp/stm32cubeide-workspace"
stm32cubeide := "/Applications/STM32CubeIDE.app/Contents/MacOS/STM32CubeIDE"

# Build Rust library
_build-rust:
    @echo "Building Rust library..."
    cd "{{project_dir}}/rust" && ./build.sh

# Run STM32CubeIDE headless build
_stm32cubeide-build config:
    {{stm32cubeide}} \
        --launcher.suppressErrors \
        -nosplash \
        -application org.eclipse.cdt.managedbuilder.core.headlessbuild \
        -data {{workspace}} \
        -build {{config}}

# Verify build output
_verify-build config:
    @if [ ! -f "{{project_dir}}/{{config}}/{{project_name}}.elf" ]; then \
        echo "Build failed: ELF file not found"; \
        exit 1; \
    fi
    @echo "Build succeeded: {{project_dir}}/{{config}}/{{project_name}}.elf"

# Initial import (run this once or after removing workspace)
import:
    rm -rf {{workspace}}
    {{stm32cubeide}} \
        --launcher.suppressErrors \
        -nosplash \
        -application org.eclipse.cdt.managedbuilder.core.headlessbuild \
        -data {{workspace}} \
        -import "{{project_dir}}"

# Build Debug configuration only
build: _build-rust
    @echo "Building STM32 project..."
    just _stm32cubeide-build {{project_name}}/Debug
    just _verify-build Debug

# Build Release configuration only
build-release: _build-rust
    @echo "Building STM32 project..."
    just _stm32cubeide-build {{project_name}}/Release || true
    just _verify-build Release

# Build using STM32CubeIDE headless (incremental build)
build-all:
    {{stm32cubeide}} \
        --launcher.suppressErrors \
        -nosplash \
        -application org.eclipse.cdt.managedbuilder.core.headlessbuild \
        -data {{workspace}} \
        -build all


# Clean build using STM32CubeIDE headless
build-clean:
    {{stm32cubeide}} \
        --launcher.suppressErrors \
        -nosplash \
        -application org.eclipse.cdt.managedbuilder.core.headlessbuild \
        -data {{workspace}} \
        -cleanBuild all


# Flash to target
_flash config:
    cd "{{project_dir}}/{{config}}" && STM32_Programmer_CLI -c port=SWD -d {{project_name}}.elf -rst

# Clean build output directories
clean:
    @echo "Cleaning Rust build..."
    cd "{{project_dir}}/rust" && cargo clean
    rm -f "{{project_dir}}/libtron_rust.a"
    @echo "Cleaning STM32 build..."
    rm -rf "{{project_dir}}/Debug"
    rm -rf "{{project_dir}}/Release"

# Flash Debug build to target
flash:
    just _flash Debug

# Flash Release build to target
flash-release:
    just _flash Release
