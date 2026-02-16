# Test Suite Safety Documentation

## ⚠️ 重要说明 (Important Notice)

**所有测试脚本都是只读的** - Tests are READ-ONLY

### 测试脚本 (Test Scripts)

#### `test_skills.sh` ✅ SAFE
**作用 (Purpose)**: 验证 SKILL.md 格式
**操作 (Operations)**:
- ✅ 只读取文件内容 (`grep`, `find`)
- ✅ 检查 Markdown 表格格式
- ❌ **不写入** 任何文件
- ❌ **不删除** 任何文件
- ❌ **不修改** 任何代码

#### `test_plugin.sh` ✅ SAFE
**作用 (Purpose)**: 验证插件结构
**操作 (Operations)**:
- ✅ 只检查文件和目录存在性
- ✅ 验证 JSON 格式
- ❌ **不修改** 任何内容

## 安全保证 (Safety Guarantees)

### 测试不会 (Tests Will NOT):
- ❌ 删除任何项目文件
- ❌ 修改任何代码
- ❌ 清空任何数据
- ❌ 影响 Git 仓库
- ❌ 运行任何危险命令

### 测试只会 (Tests Will ONLY):
- ✅ 读取文件内容
- ✅ 检查格式是否正确
- ✅ 输出验证结果到终端
- ✅ 返回退出码 (0=成功, 1=失败)

## 运行测试 (Running Tests)

```bash
# 安全运行所有测试
make test

# 或者单独运行
bash tests/test_skills.sh
bash tests/test_plugin.sh
```

**100% 安全** - 可以随时运行，不会有任何副作用。

## 如果担心 (If Concerned)

您可以先查看测试脚本内容：
```bash
cat tests/test_skills.sh
cat tests/test_plugin.sh
```

所有命令都是只读的 (`grep`, `cat`, `find`, `jq`).
