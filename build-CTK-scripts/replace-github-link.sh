for i in `ls ./*.cmake` ; do sed s/'https:\/\/github.com\/'/'git@github.com:'/g -i ${i} ; done
echo "should in [commontoolkits-CTK/CMakeExternals]"
