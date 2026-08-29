project_dir := justfile_directory() + "/mtk3bsp2_samples/IDE_Projects/mtk3bsp2_stm32h723"
project_name := "mtk3bsp2_stm32h723"
workspace := "/tmp/stm32cubeide-workspace"
stm32cubeide := "/Applications/STM32CubeIDE.app/Contents/MacOS/STM32CubeIDE"

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
build:
    {{stm32cubeide}} \
        --launcher.suppressErrors \
        -nosplash \
        -application org.eclipse.cdt.managedbuilder.core.headlessbuild \
        -data {{workspace}} \
        -build {{project_name}}/Debug

# Build Release configuration only
build-release:
    {{stm32cubeide}} \
        --launcher.suppressErrors \
        -nosplash \
        -application org.eclipse.cdt.managedbuilder.core.headlessbuild \
        -data {{workspace}} \
        -build {{project_name}}/Release

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


# Clean build output directories
clean:
    rm -rf "{{project_dir}}/Debug"
    rm -rf "{{project_dir}}/Release"

# Flash Debug build to target
flash:
    cd "{{project_dir}}/Debug" && STM32_Programmer_CLI -c port=SWD -d {{project_name}}.elf -rst

# Flash Release build to target
flash-release:
    cd "{{project_dir}}/Release" && STM32_Programmer_CLI -c port=SWD -d {{project_name}}.elf -rst
