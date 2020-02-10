%option noyywrap
%{
  #include<iostream>
  #include<map>
  #include<string>
  #include<algorithm>
  #include<vector>
  #include<ctype.h>
  #include<fstream>
  using namespace std;
  ofstream pyfile;
  map<string, string> map1, map2;
  string func_flag = "true";
  string func_name = "";
  int ifcheck = 0;
  vector<string> split(const string& str, const string& delim)
  {
  	vector<string> tokens;
  	size_t prev = 0, pos = 0;
  	do
  	{
  		pos = str.find(delim, prev);
  		if (pos == string::npos) pos = str.length();
  		string token = str.substr(prev, pos - prev);
  		if (!token.empty()) tokens.push_back(token);
  		prev = pos + delim.length();
  	} while (pos < str.length() && prev < str.length());
	return tokens;
  }
  string removeSpaces(string str)
  {
    str.erase(remove(str.begin(), str.end(), ' '), str.end());
    return str;
  }
  void warning_msg(string str)
  {
    if(pyfile.is_open())
    {
      pyfile << "#warning" << endl << str << endl;
    }
    else
    {
      pyfile.open("program1.out");
      pyfile << "#warning" << endl << str << endl;
    }
  }
  void error_msg(string str)
  {
    if(pyfile.is_open())
    {
      pyfile << "#error" << endl << str << endl;
    }
    else
    {
      pyfile.open("program1.out");
      pyfile << "#error" << endl << str << endl;
    }
  }
  void undefined_msg(string str)
  {
    if(pyfile.is_open())
    {
      pyfile << "#undefined" << endl << str << endl;
    }
    else
    {
      pyfile.open("program1.out");
      pyfile << "#undefined" << endl << str << endl;
    }
  }

%}

IDENT     [a-zA-Z][a-zA-Z0-9]*
DIGIT     [0-9][0-9]*
ASSIGN    ["="]
PLUS      ["+"]
MULTI     ["*"]
SYMB      (["("]|[")"]|[0-9]|["\/"]|["+"]|["*"]|-|["."])*
STRIN     ["\""](["\["]|["\]"]|{DIGIT}|{IDENT}|[" "])+["\""]
ADD       {IDENT}[" "]*{ASSIGN}[" "]*{DIGIT}(({PLUS}|{MULTI}){DIGIT})+
INTEGER   {IDENT}[" "]*{ASSIGN}[" "]*({DIGIT})+
VARADD    {IDENT}[" "]*{ASSIGN}[" "]*{IDENT}([" "]*{PLUS}[" "]*{IDENT})+
CONCAT    {IDENT}[" "]*{ASSIGN}[" "]*{STRIN}({PLUS}{STRIN})+
STRING    [" "]*{IDENT}[" "]*{ASSIGN}[" "]*{STRIN}
ASSIDENT  {IDENT}[" "]*{ASSIGN}[" "]*{IDENT}
ERRADD    [" "]*{IDENT}[" "]*{ASSIGN}[" "]*({DIGIT}|{STRIN}|{IDENT})[" "]*([" "]*({PLUS}|{MULTI})*[" "]*({DIGIT}|{STRIN}|{IDENT})*)+
IFELEQ    if[" "]+{IDENT}("=="){IDENT}[" "]*:
IFELNEQ   if[" "]+{IDENT}("!="){IDENT}[" "]*:
IFELGREQ  if[" "]+{IDENT}(">="){IDENT}[" "]*:
IFELLSEQ  if[" "]+{IDENT}("<="){IDENT}[" "]*:
IFELGRE   if[" "]+{IDENT}(">"){IDENT}[" "]*:
IFELLES   if[" "]+{IDENT}("<"){IDENT}[" "]*:
LISTDEC   {IDENT}[" "]*{ASSIGN}[" "]*["\["]["\]"]
LISTAPP   {IDENT}[.]append["("]({DIGIT}|{STRIN})[")"]
LISTINST  {IDENT}[.]insert["("]{DIGIT}[,]({DIGIT}|{STRIN})[")"]
LISTASS   {IDENT}["\["][0-9][0-9]*["\]"]{ASSIGN}(([0-9][0-9]*)|{STRIN})
DEFFUNC   [" "]*def[" "]*{IDENT}["("]{IDENT}([" "]*[","][" "]*{IDENT}[" "]*)*[")"][" "]*[":"]
RETFUNC   ([" "])+return[" "]*{IDENT}(({PLUS}|{MULTI}){IDENT})*
CALLFUNC  {IDENT}["("]({DIGIT}|{STRIN})([","]({DIGIT}|{STRIN}))*[")"]
LISTFUNC  ([" "])+{IDENT}[" "]*["="][" "]*["\["]["\]"]
LAPPFUNC  ([" "])+{IDENT}[.]append["("]({DIGIT}|{STRIN})[")"]
ADCLFUNC  {IDENT}[" "]*{ASSIGN}[" "]*(({IDENT}["("]({IDENT}|{DIGIT})[")"])|{STRIN}|{DIGIT}|{IDENT})[" "]*{PLUS}[" "]*({IDENT}|{DIGIT}|{STRIN}|({IDENT}["("]({IDENT}|{DIGIT})[")"]))
IDCLFUNC  {IDENT}[" "]*{ASSIGN}[" "]*{IDENT}["("]({IDENT}|{DIGIT})(([","])({IDENT}|{DIGIT}))*[")"]

%%

{INTEGER}    {
  string temp = "";
  string temp1 = "";
  string temp2 = "";
  for(int j=0; j<yyleng; j++)
  {
    temp1 = temp1 + yytext[j];
  }
  for(int i = 0; i < yyleng; i++){
    if(yytext[i] != '='){
        temp2 = temp2 + yytext[i];
    }
    else{
      break;
    }
  }
  temp = removeSpaces(temp2);
  if(map1.count(temp)==0)
  {
    map1.insert(pair <string, string>(temp,"dt_integer"));
    //cout << temp << map1.count(temp);
  }
  else
  {
    if(map1.at(temp)!="dt_integer")
    {
      //cout<<"#warning"<<endl<<temp1;
      warning_msg(temp1);
      map1.at(temp)="dt_integer";
    }
  }
  //cout << "INTEGER" << temp1 << endl;
}
{STRING}    {
  string temp = "";
  string temp1 = "";
  string temp2 = "";
  for(int j=0; j<yyleng; j++)
  {
    temp1 = temp1 + yytext[j];
  }
  for(int i = 0; i < yyleng; i++){
    if(yytext[i] != '='){
        temp2 = temp2 + yytext[i];
    }
    else{
      break;
    }
  }
  temp = removeSpaces(temp2);
  if(map1.count(temp)==0)
  {
    map1.insert(pair <string, string>(temp,"dt_string"));
  }
  else
  {
    if(map1.at(temp)!="dt_string")
    {
      //cout<<"#warning"<<endl<<temp1;
      warning_msg(temp1);
      map1.at(temp)="dt_string";
    }
  }
  //cout << "STRING" << temp1 << endl;
}
{CONCAT}    {
  string temp = "";
  string temp1 = "";
  for(int j=0; j<yyleng; j++)
  {
    temp1 = temp1 + yytext[j];
  }
  for(int i = 0; i < yyleng; i++){
    if(yytext[i] != '='){
        temp = temp + yytext[i];
    }
    else{
      break;
    }
  }
  //cout << map1.count(temp) << temp;
  if(map1.count(temp)==0)
  {
    map1.insert(pair <string, string>(temp,"dt_string"));
  }
  else
  {
    if(map1.at(temp)!="dt_string")
    {
      //cout<<"#error"<<endl<<temp1;
      error_msg(temp1);
    }
  }
  //cout << "CONCAT" << temp1<< endl;
}
{ADD}   {
  string temp = "";
  string temp1 = "";
  string temp2 = "";
  for(int j=0; j<yyleng; j++)
  {
    temp1 = temp1 + yytext[j];
  }
  for(int i = 0; i < yyleng; i++){
    if(yytext[i] != '='){
        temp2 = temp2 + yytext[i];
    }
    else{
      break;
    }
  }
  temp = removeSpaces(temp2);
  if(map1.count(temp)==0)
  {
    map1.insert(pair <string, string>(temp,"dt_integer"));
  }
  else
  {
    if(map1.at(temp)=="dt_string")
    {
      //cout << "#warning" << endl << temp1;
      warning_msg(temp1);
      map1.at(temp)="dt_integer";
    }
    else if(map1.at(temp)=="dt_integer")
    { }
    else
    {
      //cout<<"#error"<<endl<<temp1;
      error_msg(temp1);
    }
  }
  //cout << "ADD" << temp1<< endl;
}
{VARADD}    {
  string temp = "";
  string temp1 = "";
  string temp2 = "";
  string assign_r = "";
  for(int j=0; j<yyleng; j++)
  {
    temp1 = temp1 + yytext[j];
  }
  for(int i = 0; i < yyleng; i++){
    if(yytext[i] != '='){
        temp = temp + yytext[i];
    }
    else{
      break;
    }
  }
  temp2 = removeSpaces(temp1);
  temp = removeSpaces(temp);
  assign_r = temp2.substr(temp2.find("=") + 1, temp2.length());
  assign_r = removeSpaces(assign_r);
  vector<string> out = split(assign_r, "+");
  string check = "";
  int val = 0;
  check = map1.at(out[0]);
  for(unsigned p=0; p<out.size(); p++)
  {
    if(check=="dt_list_int" || check=="dt_list_str")
    {
      if(map1.at(out[p])!=check)
      {
        //cout << "#warning" << endl << temp1;
        warning_msg(temp1);
      }
    }
    else
    {
      if(map1.at(out[p])!=check)
      {
        //cout << "#error" << endl << temp1;
        error_msg(temp1);
        val = 1;
      }
    }
  }
  if(val==0)
  {
    if(map1.count(temp)!=0)
    {
      //cout << "#warning" << endl << temp1;
      warning_msg(temp1);
      map1.at(temp) = map1.at(out[0]);
    }
    else
    {
      map1.insert(pair <string, string>(temp,map1.at(out[0])));
    }
  }
  //cout << "VARADD" << temp1<< endl;
}
{ASSIDENT}    {
  string temp = "";
  string temp1 = "";
  string assign_r = "";
  for(int j=0; j<yyleng; j++)
  {
    temp1 = temp1 + yytext[j];
  }
  for(int i = 0; i < yyleng; i++){
    if(yytext[i] != '='){
        temp = temp + yytext[i];
    }
    else{
      break;
    }
  }
  assign_r = temp1.substr(temp1.find("=") + 1, temp1.length());
  assign_r = removeSpaces(assign_r);
  temp=removeSpaces(temp);
  if(map1.count(assign_r)==0)
  {
    //cout << "#undefined"<<endl<<temp1;
    undefined_msg(temp1);
  }
  else
  {
    if(map1.count(temp)!=0)
    {
      if(map1.at(temp)!=map1.at(assign_r))
      {
        //cout<<"#warning"<<endl<<temp1;
        warning_msg(temp1);
        map1.at(temp)=map1.at(assign_r);
      }
    }
    else
    {
      map1.insert(pair <string, string>(temp,map1.at(assign_r)));
    }
  }
  //cout << "ASSIDENT" << temp1<< endl;
}
{ERRADD}    {
  string stringy = "";//temp
  string line = "";//temp1
  string assign_l = "";//temp2
  vector<string> plus_s;
  for(int j=0; j<yyleng; j++)
  {
    line = line + yytext[j];
  }
  for(int i = 0; i < yyleng; i++){
    if(yytext[i] != '='){
        assign_l = assign_l + yytext[i];
    }
    else{
      break;
    }
  }
  stringy = removeSpaces(assign_l);
  string assign_r = line.substr(line.find("=") + 1, line.length());
  assign_r = removeSpaces(assign_r);
  assign_l = removeSpaces(assign_l);
  int plus_err=0;
  for(int c=0; c<assign_r.length(); c++)
  {
    if(assign_r[c]=='+' || assign_r[c]=='*')
    {
      plus_err++;
    }
  }
  if(func_name=="")
  {
    if(plus_err==0)
    {
      if(assign_r[0]=='\"')
      {
        if(map1.count(assign_l)==0)
        {
          map1.insert(pair <string, string>(assign_l,"dt_string"));
        }
        else
        {
          if(map1.at(assign_l)!="dt_string")
          {
            //cout<<"#warning"<<endl<<line;
            warning_msg(line);
            map1.at(assign_l)="dt_string";
          }
        }
      }
      else if(isalpha(assign_r[0]))
      {
        if(map1.count(assign_r)==0)
        {
          //cout << "#1undefined"<<endl<<line;
          undefined_msg(line);
        }
        else
        {
          if(map1.count(assign_l)==0)
          {
            map1.insert(pair <string, string>(assign_l,map1.at(assign_r)));
            //cout << assign_l << map1.count(assign_l);
          }
          else
          {
            if(map1.at(assign_l)!=map1.at(assign_r))
            {
              //cout<<"#warning"<<endl<<line;
              warning_msg(line);
              map1.at(assign_l)=map1.at(assign_r);
            }
          }
        }
      }
      else if(isdigit(assign_r[0]))
      {
        if(map1.count(assign_l)==0)
        {
          map1.insert(pair <string, string>(assign_l,"dt_integer"));
        }
        else
        {
          if(map1.at(assign_l)!="dt_integer")
          {
            //cout<<"#warning"<<endl<<line;
            warning_msg(line);
            map1.at(assign_l)="dt_integer";
          }
        }
      }
    }
    else
    {
      vector<string> out = split(assign_r, "+");
      //multiplication case
      vector<string> out1;
      if(assign_r.find("*")!=0)
      {
        for(unsigned q=0; q<out.size();q++)
        {
          for(int y=0;y<out[q].size();y++)
          {
            if(out[q][y]=='*')
            {
              out1 = split(out[q],"*");
            }
          }
        }
      }
      string multi_type;
      if(out1.size()>0)
      {
        for(unsigned n=0; n<out1.size(); n++)
        {
          if(isalpha(out1[n][0]))
          {
            multi_type = map1.at(out1[n]);
          }
        }
      }
      int che = 0;
      if(assign_r.find("*")!=0)
      {
        for(unsigned t=0; t<out1.size(); t++)
        {
          if(map1.count(stringy)==0)
          {
            if(isdigit(out1[t][0]))
            {
              map1.insert(pair <string, string>(stringy,"dt_integer"));
            }
            else
            {
              if(map1.at(out1[t])!="dt_string")
              {
                if(map1.count(out1[t])==0)
                {
                  //cout << "#undefined" << endl << line;
                  undefined_msg(line);
                  che = 1;
                  break;
                }
                else
                {
                  if(map1.at(out1[t])==multi_type)
                  {
                    map1.insert(pair <string, string>(stringy,map1.at(out1[t])));
                  }
                  else
                  {
                    //cout << "#error" << endl << line;
                    error_msg(line);
                    che = 1;
                    break;
                  }
                }
              }
              else
              {
                //cout << "#1error" << endl << line;
                error_msg(line);
                che = 1;
                break;
              }
            }
          }
          else
          {
            if(isdigit(out1[t][0]))
            {
              if(map1.at(stringy)!="dt_integer")
              {
                //cout << "#error" << endl << line;
                error_msg(line);
                che = 1;
                break;
              }
            }
            else
            {
              if(map1.count(out1[t])==0)
              {
                //cout << "#undefined" << endl << line;
                undefined_msg(line);
                che = 1;
                break;
              }
              else
              {
                if(map1.at(out1[t])!=multi_type)
                {
                  //cout << "#error" << endl << line;
                  error_msg(line);
                  che = 1;
                  break;
                }
              }
            }
          }
        }
      }
      //only + case
      int iop = 0;
      for (int h=0; h<assign_r.length(); h++)
      {
        if(assign_r[h]=='+')
        {
          iop=1;
        }
      }
      if(che==0 && iop==1)
      {
        for(unsigned r=0;r<out.size();r++)
        {
          if(map1.count(stringy)==0)
          {
            if(isalpha(out[r][0]))
            {
              if(map1.count(out[r])==0)
              {
                //cout << "#undefined" << endl << line;
                undefined_msg(line);
                break;
              }
              else
              {
                map1.insert(pair <string, string>(stringy,map1.at(out[r])));
              }
            }
            else if(isdigit(out[r][0]))
            {
              map1.insert(pair <string, string>(stringy,"dt_integer"));
            }
            else if(out[r][0]=='\"')
            {
              map1.insert(pair <string, string>(stringy,"dt_string"));
            }
          }
          else
          {
            vector<string> out2, out3, out4;
            for(unsigned g=0; g<out.size(); g++)
            {
              for(unsigned f=0; f<out[g].size(); f++)
              {
                if(out[g][f]=='*')
                {
                  out2 = split(assign_r, "*");
                }
              }
            }
            for(unsigned w=0; w<out2.size(); w++)
            {
              for(unsigned v=0; v<out2[w].size(); v++)
              {
                if(out2[w][v]=='+')
                {
                  out3 = split(out2[w], "+");
                  out.clear();
                }
              }
            }
            //out.clear();
            for(unsigned w=0; w<out2.size(); w++)
            {
              for(unsigned v=0; v<out2[w].size(); v++)
              {
                if(out2[w][v]=='*')
                {
                  out4 = split(out2[w], "*");
                  out.clear();
                }
              }
            }
            out.insert(out.end(), out3.begin(), out3.end());
            out.insert(out.end(), out4.begin(), out4.end());
            if(isalpha(out[r][0]))
            {
              if(map1.count(out[r])==0)
              {
                //cout << "#undefined" << endl << line;
                undefined_msg(line);
                break;
              }
              else
              {
                if(map1.at(stringy)!=map1.at(out[r]))
                {
                  //cout << "#error" << endl << line;
                  error_msg(line);
                  break;
                }
              }
            }
            else if(isdigit(out[r][0]))
            {
              if(map1.at(stringy)!="dt_integer")
              {
                //cout << "#error" << endl << line;
                error_msg(line);
                break;
              }
            }
            else if(out[r][0]=='\"')
            {
              if(map1.at(stringy)!="dt_string")
              {
                //cout << "#error" << endl << line;
                error_msg(line);
              }
            }
          }
        }
      }
    }
  }
  //else case
  else
  {
    int pluses = 0;
    for(int b=0; b<assign_r.length(); b++)
    {
      if(assign_r[b]=='+')
      {
        pluses++;
      }
    }
    if(pluses>0)
    {
      plus_s = split(assign_r,"+");
      string checku="";
      for(unsigned p=0; p<plus_s.size(); p++)
      {
        if(isalpha(plus_s[p][0]))
        {
          if(checku=="")
          {
            if(map1.count(plus_s[p])!=0)
            {
              checku=map1.at(plus_s[p]);
              if(map2.count(assign_l)==0)
              {
                map2.insert(pair <string, string>(assign_l,checku));
              }
              else
              {
                map2.at(assign_l) = checku;
              }
            }
            if(map2.count(plus_s[p])!=0)
            {
              if(map2.count(assign_l)==0)
              {
                map2.insert(pair <string, string>(assign_l,map2.at(plus_s[p])));
              }
              else
              {
                map2.at(assign_l) = map2.at(plus_s[p]);
              }
            }
          }
          else if(map1.at(plus_s[p])!=checku)
          {
            //cout << "#error" << line << endl;
            error_msg(line);
            break;
          }
        }
        else if(isdigit(plus_s[p][0]))
        {
          if(checku=="")
          {
            checku="dt_integer";
            //cout << map2.count(assign_l) << assign_l;
            if(map2.count(assign_l)==0)
            {
              map2.insert(pair <string, string>(assign_l,checku));
            }
            else
            {
              map2.at(assign_l) = checku;
            }
          }
          else if(checku!="dt_integer")
          {
            //cout << "#error" << line << endl;
            error_msg(line);
            break;
          }
        }
      }
    }
    else
    {
      if(map2.count(assign_l)!=0)
      {
        if(map1.at(assign_l)!="dt_integer")
        {
          //cout<<"#warning"<<endl<<line;
          warning_msg(line);
          map2.at(assign_l)="dt_integer";
        }
      }
      else
      {
        map2.insert(pair <string, string>(assign_l,"dt_integer"));
      }
    }
    //cout << "LNFUNC" << line << endl;
  }
  //cout << "ERRADD" << line << endl;
}
{IFELEQ}    {
  string temp="";
  string temp1 = "";
  for(int j=0; j<yyleng; j++)
  {
    temp1 = temp1 + yytext[j];
  }
  int val=0;
  string condition = temp1.substr(3,temp1.length());
  for(int i = 0; i < condition.length(); i++){
    if(condition[i] != ':'){
        temp = temp + condition[i];
    }
    else{
      break;
    }
  }
  vector<string> out = split(temp, "==");
  for(unsigned r=0; r<out.size()-1; r++)
  {
    if(map1.at(out[r])!=map1.at(out[r+1]))
    {
      //cout << "#warning" << endl << temp1;
      warning_msg(temp1);
    }
  }
  ifcheck = 1;
  //cout << "IFELEQ" << temp1 << endl;
}
{IFELNEQ}   {
  string temp="";
  string temp1 = "";
  for(int j=0; j<yyleng; j++)
  {
    temp1 = temp1 + yytext[j];
  }
  int val=0;
  string condition = temp1.substr(3,temp1.length());
  for(int i = 0; i < condition.length(); i++){
    if(condition[i] != ':'){
        temp = temp + condition[i];
    }
    else{
      break;
    }
  }
  vector<string> out = split(temp, "!=");
  for(unsigned r=0; r<out.size()-1; r++)
  {
    if(map1.at(out[r])!=map1.at(out[r+1]))
    {
      //cout << "#error" << endl << temp1;
      error_msg(temp1);
    }
  }
  ifcheck = 1;
  //cout << "IFELNEQ" << temp1 << endl;
}
{IFELGREQ}    {
  string temp="";
  string temp1 = "";
  for(int j=0; j<yyleng; j++)
  {
    temp1 = temp1 + yytext[j];
  }
  int val=0;
  string condition = temp1.substr(3,temp1.length());
  for(int i = 0; i < condition.length(); i++){
    if(condition[i] != ':'){
        temp = temp + condition[i];
    }
    else{
      break;
    }
  }
  vector<string> out = split(temp, ">=");
  for(unsigned r=0; r<out.size()-1; r++)
  {
    if(map1.at(out[r])!=map1.at(out[r+1]))
    {
      //cout << "#error" << endl << temp1;
      error_msg(temp1);
    }
  }
  ifcheck = 1;
  //cout << "IFELGREQ" << temp1 << endl;
}
{IFELLSEQ}    {
  string temp="";
  string temp1 = "";
  for(int j=0; j<yyleng; j++)
  {
    temp1 = temp1 + yytext[j];
  }
  int val=0;
  string condition = temp1.substr(3,temp1.length());
  for(int i = 0; i < condition.length(); i++){
    if(condition[i] != ':'){
        temp = temp + condition[i];
    }
    else{
      break;
    }
  }
  vector<string> out = split(temp, "<=");
  for(unsigned r=0; r<out.size()-1; r++)
  {
    if(map1.at(out[r])!=map1.at(out[r+1]))
    {
      //cout << "#error" << endl << temp1;
      error_msg(temp1);
    }
  }
  ifcheck = 1;
  //cout << "IFELLESQ" << temp1 << endl;
}
{IFELGRE}   {
  string temp="";
  string temp1 = "";
  for(int j=0; j<yyleng; j++)
  {
    temp1 = temp1 + yytext[j];
  }
  int val=0;
  string condition = temp1.substr(3,temp1.length());
  for(int i = 0; i < condition.length(); i++){
    if(condition[i] != ':'){
        temp = temp + condition[i];
    }
    else{
      break;
    }
  }
  vector<string> out = split(temp, ">");
  for(unsigned r=0; r<out.size()-1; r++)
  {
    if(map1.at(out[r])!=map1.at(out[r+1]))
    {
      //cout << "#error" << endl << temp1;
      error_msg(temp1);
    }
  }
  ifcheck = 1;
  //cout << "IFELGRE" << temp1 << endl;
}
{IFELLES}   {
  string temp="";
  string temp1 = "";
  for(int j=0; j<yyleng; j++)
  {
    temp1 = temp1 + yytext[j];
  }
  int val=0;
  string condition = temp1.substr(3,temp1.length());
  for(int i = 0; i < condition.length(); i++){
    if(condition[i] != ':'){
        temp = temp + condition[i];
    }
    else{
      break;
    }
  }
  vector<string> out = split(temp, "<");
  for(unsigned r=0; r<out.size()-1; r++)
  {
    if(map1.at(out[r])!=map1.at(out[r+1]))
    {
      //cout << "#error" << endl << temp1;
      error_msg(temp1);
    }
  }
  ifcheck = 1;
  //cout << "IFELLES" << temp1 << endl;
}
{LISTDEC}   {
  string temp="";
  string temp1 = "";
  for(int j=0; j<yyleng; j++)
  {
    temp1 = temp1 + yytext[j];
  }
  for(int i = 0; i < yyleng; i++){
    if(yytext[i] != '='){
        temp = temp + yytext[i];
    }
    else{
      break;
    }
  }
  temp = removeSpaces(temp);
  map1.insert(pair <string, string>(temp,"dt_list"));
}
{LISTAPP}   {
  string temp="";
  string temp1 = "";
  for(int j=0; j<yyleng; j++)
  {
    temp1 = temp1 + yytext[j];
  }
  for(int i = 0; i < yyleng; i++){
    if(yytext[i] != '.'){
        temp = temp + yytext[i];
    }
    else{
      break;
    }
  }
  string assign_r = temp1.substr(temp1.find("(") + 1, temp1.length());
  string assign_t = assign_r.substr(0,assign_r.length()-1);
  assign_t = removeSpaces(assign_t);
  if (isdigit(assign_t[0]))
  {
    if(map1.count(temp)==0)
    {
      //cout << "#error" << endl << temp1;
      error_msg(temp1);
      break;
    }
    else
    {
      if(map1.at(temp)=="dt_list")
      {
        map1.at(temp) = "dt_list_int";
      }
      else if(map1.at(temp)=="dt_list_str")
      {
        //cout << "#warning" << endl << temp1;
        warning_msg(temp1);
      }
      else if (map1.at(temp)=="dt_list_int")
      {      }
      else
      {
        //cout << "#error" << endl << temp1;
        error_msg(temp1);
      }
    }
  }
  else if(assign_t[0]=='\"')
  {
    if(map1.count(temp)==0)
    {
      //cout << "#error" << endl << temp1;
      error_msg(temp1);
      break;
    }
    else
    {
      if(map1.at(temp)=="dt_list")
      {
        map1.at(temp) = "dt_list_str";
      }
      else if(map1.at(temp)=="dt_list_int")
      {
        //cout << "#warning" << endl << temp1;
        warning_msg(temp1);
      }
      else if (map1.at(temp)=="dt_list_str")
      {      }
      else
      {
        //cout << "#error" << endl << temp1;
        error_msg(temp1);
      }
    }
  }
  //cout << temp1 << "LISTAPP" << endl;
}
{LISTINST}    {
  string temp="";
  string temp1 = "";
  for(int j=0; j<yyleng; j++)
  {
    temp1 = temp1 + yytext[j];
  }
  for(int i = 0; i < yyleng; i++){
    if(yytext[i] != '.'){
        temp = temp + yytext[i];
    }
    else{
      break;
    }
  }
  string assign_r = temp1.substr(temp1.find("(") + 1, temp1.length());
  string assign_t = assign_r.substr(0,assign_r.length()-1);
  string assign_c = assign_t.substr(assign_t.find(",") + 1, assign_t.length());
  if (isdigit(assign_c[0]))
  {
    if(map1.count(temp)==0)
    {
      map1.insert(pair <string, string>(temp,"dt_list_int"));
    }
    else
    {
      if(map1.at(temp)=="dt_list")
      {
        map1.at(temp) = "dt_list_int";
      }
      else if(map1.at(temp)=="dt_list_str")
      {
        //cout << "#warning" << endl << temp1;
        warning_msg(temp1);
      }
      else if (map1.at(temp)=="dt_list_int")
      {}
      else
      {
        //cout << "#error" << endl << temp1;
        error_msg(temp1);
      }
    }
  }
  else if(assign_c[0]=='\"')
  {
    if(map1.count(temp)==0)
    {
      map1.insert(pair <string, string>(temp,"dt_list_str"));
    }
    else
    {
      if(map1.at(temp)=="dt_list")
      {
        map1.at(temp) = "dt_list_str";
      }
      else if(map1.at(temp)=="dt_list_int")
      {
        //cout << "#warning" << endl << temp1;
        warning_msg(temp1);
      }
      else if (map1.at(temp)=="dt_list_str")
      {}
      else
      {
        //cout << "#error" << endl << temp1;
        error_msg(temp1);
      }
    }
  }
}
{LISTASS}   {
  string temp="";
  string temp1 = "";
  for(int j=0; j<yyleng; j++)
  {
    temp1 = temp1 + yytext[j];
  }
  for(int i = 0; i < yyleng; i++){
    if(yytext[i] != '\['){
        temp = temp + yytext[i];
    }
    else{
      break;
    }
  }
  string assign_r = temp1.substr(temp1.find("=") + 1, temp1.length());
  if (isdigit(assign_r[0]))
  {
    if(map1.count(temp)==0)
    {
      map1.insert(pair <string, string>(temp,"dt_list_int"));
    }
    else
    {
      if(map1.at(temp)=="dt_list")
      {
        map1.at(temp) = "dt_list_int";
      }
      else if(map1.at(temp)=="dt_list_str")
      {
        //cout << "#warning" << endl << temp1;
        warning_msg(temp1);
      }
      else
      {
        //cout << "#error" << endl << temp1;
        error_msg(temp1);
      }
    }
  }
  else if(assign_r[0]=='\"')
  {
    if(map1.count(temp)==0)
    {
      map1.insert(pair <string, string>(temp,"dt_list_str"));
    }
    else
    {
      if(map1.at(temp)=="dt_list")
      {
        map1.at(temp) = "dt_list_str";
      }
      else if(map1.at(temp)=="dt_list_int")
      {
        //cout << "#warning" << endl << temp1;
        warning_msg(temp1);
      }
      else
      {
        //cout << "#error" << endl << temp1;
        error_msg(temp1);
      }
    }
  }
}
{DEFFUNC} {
  string temp="";
  string temp1 = "";
  string temp2="";
  string funcname = "";
  vector <string> funcvec;
  for(int j=0; j<yyleng; j++)
  {
    temp1 = temp1 + yytext[j];
  }
  temp = temp1.substr(temp1.find("(")+1,temp1.length());
  for(int i = 0; i < temp.length(); i++){
    if(temp[i] != ')'){
        temp2 = temp2 + temp[i];
    }
    else{
      break;
    }
  }
  for(int q = 0; q < temp1.length(); q++){
    if(temp1[q] != '('){
        funcname = funcname + temp1[q];
    }
    else{
      break;
    }
  }
  funcname = funcname.erase(0,4);
  func_name = funcname;
  funcvec = split(temp2, ",");
  map2.insert(pair <string, string>(funcname,temp2));
}
{RETFUNC}   {
  string line, expr, retmap, rettype;
  int addi=0, multi=0;
  for(int j=0; j<yyleng; j++)
  {
    line = line + yytext[j];
  }
  expr = line.substr(line.find("n")+1,line.length());
  expr = removeSpaces(expr);
  retmap = "return_" + func_name;
  rettype = func_name + "_type";
  map2.insert(pair <string, string>(retmap,expr));
  for(int i=0; i<expr.length(); i++)
  {
    if(expr[i]=='+')
    {
      addi++;
    }
    if(expr[i]=='*')
    {
      multi++;
    }
  }
  vector<string> addia, multia, mix;
  if(addi==0 && multi==0)
  {
    map2.insert(pair <string, string>(rettype,map2.at(expr)));
  }
  else if(addi!=0 && multi==0)
  {
    addia = split(expr,"+");
    map2.insert(pair <string, string>(rettype,map2.at(addia[0])));
  }
  else if(addi==0 && multi!=0)
  {
    multia = split(expr, "*");
  }
  func_name="";
  //cout << "RETFUNC" << line << endl;
}
{CALLFUNC}    {
  string line, retfun_name, func_expr, fname, pre_eval, eval;
  for(int j=0; j<yyleng; j++)
  {
    line = line + yytext[j];
  }
  for(int i = 0; i < line.length(); i++)
  {
    if(line[i] != '('){
        fname = fname + line[i];
    }
    else{
      break;
    }
  }
  retfun_name = "return_" + fname;
  func_expr = map2.at(retfun_name);
  pre_eval = line.substr(line.find("(")+1, line.length());
  for(int y=0; y<pre_eval.length(); y++)
  {
    if(pre_eval[y]!=')')
    {
      eval = eval + pre_eval[y];
    }
  }
  vector<string> posteval, listadd;
  posteval = split(eval, ",");
  int multi = 0, checked=0, addi=0, checkad=0, listcheck=0;
  string cheadd="";
  for(int x=0; x<func_expr.length(); x++)
  {
    if(func_expr[x]=='*')
    {
      multi++;
    }
    if(func_expr[x]=='+')
    {
      addi++;
    }
  }
  if(addi>0 && multi==0)
  {
    listadd = split(func_expr,"+");
    for(unsigned u=0; u<listadd.size(); u++)
    {
      if(map2.count(listadd[u])!=0)
      {
        if(map2.at(listadd[u])=="dt_list")
        {
          listcheck=1;
        }
      }
    }
  }
  if(multi>0)
  {
    for(unsigned l=0; l<posteval.size(); l++)
    {
      if(checked==0)
      {
        for(unsigned k=0; k<posteval[l].size(); k++)
        {
          if(posteval[l][k]=='\"')
          {
            //cout << "#error" << line << endl;
            error_msg(line);
            checked=1;
            break;
          }
        }
      }
    }
  }
  else if(multi==0 && addi>0)
  {
    for(unsigned f=0; f<posteval.size(); f++)
    {
      if(checkad==0)
      {
        if(posteval[f][0]=='\"')
        {
          cheadd = "string";
          checkad = 1;
        }
        else if(isdigit(posteval[f][0]))
        {
          cheadd = "integer";
          checkad = 1;
        }
      }
      else
      {
        if(cheadd=="integer")
        {
          if(!isdigit(posteval[f][0]))
          {
            if(listcheck==0)
            {
              //cout << "#error" << line << endl;
              error_msg(line);
              break;
            }
            else
            {
              //cout << "#warning" << line << endl;
              warning_msg(line);
              break;
            }
          }
        }
        else if(cheadd=="string")
        {
          if(posteval[f][0]!='\"')
          {
            if(listcheck==0)
            {
              //cout << "#error" << line << endl;
              error_msg(line);
              break;
            }
            else
            {
              //cout << "#warning" << line << endl;
              warning_msg(line);
              break;
            }
          }
        }
      }
    }
  }
  //cout << line << "CALLFUNC" << endl;
}
{LISTFUNC}    {
  string line, assign_l;
  for(int j=0; j<yyleng; j++)
  {
    line = line + yytext[j];
  }
  line = removeSpaces(line);
  for(int i = 0; i < line.length(); i++){
    if(line[i] != '='){
        assign_l = assign_l + line[i];
    }
    else{
      break;
    }
  }
  map2.insert(pair <string, string>(assign_l,"dt_list"));
}
{LAPPFUNC}    {
  string line, assign_l;
  for(int j=0; j<yyleng; j++)
  {
    line = line + yytext[j];
  }
  line = removeSpaces(line);
  for(int i = 0; i < line.length(); i++){
    if(line[i] != '.'){
        assign_l = assign_l + line[i];
    }
    else{
      break;
    }
  }
  string assign_r = line.substr(line.find("(") + 1, line.length());
  string assign_t = assign_r.substr(0,assign_r.length()-1);
  assign_t = removeSpaces(assign_t);
  if(func_name!="")
  {
    if (isdigit(assign_t[0]))
    {
      if(map2.count(assign_l)==0)
      {
        map2.insert(pair <string, string>(assign_l,"dt_list_int"));
      }
      else
      {
        if(map2.at(assign_l)=="dt_list")
        {
          map2.at(assign_l) = "dt_list_int";
        }
        else if(map2.at(assign_l)=="dt_list_str")
        {
          //cout << "#warning" << endl << line;
          warning_msg(line);
        }
        else if (map2.at(assign_l)=="dt_list_int")
        {      }
        else
        {
          //cout << "#error" << endl << line;
          error_msg(line);
        }
      }
    }
    else if(assign_t[0]=='\"')
    {
      if(map2.count(assign_l)==0)
      {
        map2.insert(pair <string, string>(assign_l,"dt_list_str"));
      }
      else
      {
        if(map2.at(assign_l)=="dt_list")
        {
          map2.at(assign_l) = "dt_list_str";
        }
        else if(map2.at(assign_l)=="dt_list_int")
        {
          //cout << "#warning" << endl << line;
          warning_msg(line);
        }
        else if (map2.at(assign_l)=="dt_list_str")
        {      }
        else
        {
          //cout << "#error" << endl << line;
          error_msg(line);
        }
      }
    }
  }
  else
  {
    if (isdigit(assign_t[0]))
    {
      if(map1.count(assign_l)==0)
      {
        //cout << "#error" << endl << line;
        error_msg(line);
        break;
      }
      else
      {
        if(map1.at(assign_l)=="dt_list")
        {
          map1.at(assign_l) = "dt_list_int";
        }
        else if(map1.at(assign_l)=="dt_list_str")
        {
          //cout << "#warning" << endl << line;
          warning_msg(line);
        }
        else if (map1.at(assign_l)=="dt_list_int")
        {      }
        else
        {
          //cout << "#error" << endl << line;
          error_msg(line);
        }
      }
    }
    else if(assign_t[0]=='\"')
    {
      if(map1.count(assign_l)==0)
      {
        //cout << "#error" << endl << line;
        error_msg(line);
        break;
      }
      else
      {
        if(map1.at(assign_l)=="dt_list")
        {
          map1.at(assign_l) = "dt_list_str";
        }
        else if(map1.at(assign_l)=="dt_list_int")
        {
          //cout << "#warning" << endl << line;
          warning_msg(line);
          //map1.at(temp) = "dt_list_str";
        }
        else if (map1.at(assign_l)=="dt_list_str")
        {      }
        else
        {
          //cout << "#error" << endl << line;
          error_msg(line);
        }
      }
    }
  }
  //cout << "LISTAPP" << line << endl;
}
{IDCLFUNC}    {
  string line, assign_l, assign_r_f, assign_r_func, argu, argum;
  for(int j=0; j<yyleng; j++)
  {
    line = line + yytext[j];
  }
  line = removeSpaces(line);
  for(int i = 0; i < line.length(); i++){
    if(line[i] != '='){
        assign_l = assign_l + line[i];
    }
    else{
      break;
    }
  }
  assign_l = removeSpaces(assign_l);
  assign_r_f = line.substr(line.find("=")+1,line.length());
  for(int y=0; y<assign_r_f.length(); y++)
  {
    if(assign_r_f[y]!='(')
    {
      assign_r_func = assign_r_func + assign_r_f[y];
    }
    else {break;}
  }
  assign_r_func = removeSpaces(assign_r_func);
  argu = line.substr(line.find("(")+1, line.length());
  for(int x=0; x<argu.length(); x++)
  {
    if(argu[x]!=')')
    {
      argum = argum + argu[x];
    }
    else {break;}
  }
  argu = removeSpaces(argu);
  string rett;
  rett = assign_r_func + "_type";
  if(map1.count(assign_l)==0)
  {
    map1.insert(pair <string, string>(assign_l,map2.at(rett)));
  }
  else
  {
    if(map1.at(assign_l)!=map2.at(rett))
    {
      //cout << "#warning" << line << endl;
      warning_msg(line);
      map1.at(assign_l) = map2.at(rett);
      break;
    }
  }
  //cout << "IDCLFUNC" << line << endl;
}
{ADCLFUNC}    {
  string line, assign_l, assign_r;
  for(int j=0; j<yyleng; j++)
  {
    line = line + yytext[j];
  }
  line = removeSpaces(line);
  for(int i = 0; i < line.length(); i++){
    if(line[i] != '='){
        assign_l = assign_l + line[i];
    }
    else{
      break;
    }
  }
  assign_l = removeSpaces(assign_l);
  assign_r = line.substr(line.find("=")+1,line.length());
  assign_r = removeSpaces(assign_r);
  vector<string> plus_div;
  string checkedf="", funcv="", retty;
  plus_div = split(assign_r,"+");
  for(unsigned v=0; v<plus_div.size(); v++)
  {
    if(plus_div[v][0]=='\"')
    {
      if(checkedf=="")
      {
        checkedf = "dt_string";
      }
      else
      {
        if(checkedf!="dt_string")
        {
          //cout << "#error" << line << endl;
          error_msg(line);
          break;
        }
      }
    }
    else if(isalpha(plus_div[v][0]))
    {
      int parenth=0;
      for(unsigned h=0; h<plus_div[v].size(); h++)
      {
        if(plus_div[v][h]=='(' || plus_div[v][h]==')')
        {
          parenth++;
        }
      }
      if(parenth>0)
      {
        for(int c=0; c<assign_r.length(); c++)
        {
          if(assign_r[c]!='(')
          {
            funcv = funcv + assign_r[c];
          }
          else {break;}
        }
        retty = funcv + "_type";
        if(checkedf=="")
        {
          checkedf = map2.at(retty);
        }
        else
        {
          if(checkedf!=map2.at(retty))
          {
            //cout << "#error" << line << endl;
            error_msg(line);
            break;
          }
        }
      }
      else
      {
        if(map1.count(plus_div[v])==0)
        {
          //cout << "#undefined" << line << endl;
          undefined_msg(line);
          break;
        }
        else
        {
          if(checkedf=="")
          {
            checkedf = map1.at(plus_div[v]);
          }
          else
          {
            if(map1.at(plus_div[v])!=checkedf)
            {
              //cout << "#error" << line << endl;
              error_msg(line);
              break;
            }
          }
        }
      }
    }
    else if(isdigit(plus_div[v][0]))
    {
      if(checkedf=="")
      {
        checkedf = "dt_integer";
      }
      else
      {
        if(checkedf!="dt_integer")
        {
          //cout << "#error" << line << endl;
          error_msg(line);
          break;
        }
      }
    }
  }
  //cout << "ADCLFUNC" << line << endl;
}
.   {  }

%%
