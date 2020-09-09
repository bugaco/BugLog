# 记录git的一个报错：`Commit failed - exit code 1 received`



在命令行下，输入```git status```，显示有红色，提示用```git add```命令，但是输入```git add .```之后，无效。

用```Github Desktop.app```提交，返回了```Commit failed - exit code 1 received```错误，Google了一下，可能是因为引入了多余的`.git`文件夹引起的，[参考自：Commit failed - exit code 1 received #4432](https://github.com/desktop/desktop/issues/4432)

找到移除多余的`.git`文件夹后，该问题解决了





