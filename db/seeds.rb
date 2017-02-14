Member.connection.execute("DELETE FROM `#{Member.table_name}`;")
Member.create({\
"name"=>"太郎",\
"yomi"=>"たろう",\
"email"=>"taro@b.c"\
})
Member.create({\
"name"=>"博士",\
"yomi"=>"ひろし",\
"email"=>"hiroshi@b.c"\
})
Member.create({\
"name"=>"花子",\
"yomi"=>"はなこ",\
"email"=>"hanako@b.c"\
})

Participant.connection.execute("DELETE FROM `#{Participant.table_name}`;")
Participant.create({\
"email"=>"takeshi@b.c",\
"name"=>"武志",\
"yomi"=>"たけし",\
"gender"=>1,\
"birth"=>Date.new(1995, 12, 18),\
"classification"=>1,\
"grade"=>3,\
"faculty"=>1,\
"address"=>"百万遍"\
})
Participant.create({\
"email"=>"satoshi@b.c",\
"name"=>"悟志",\
"yomi"=>"さとし",\
"gender"=>1,\
"birth"=>Date.new(1993, 6, 8),\
"classification"=>2,\
"grade"=>1,\
"faculty"=>2,\
"address"=>"出町柳"\
})
Participant.create({\
"email"=>"rika@b.c",\
"name"=>"梨花",\
"yomi"=>"りか",\
"gender"=>2,\
"birth"=>Date.new(1991, 9, 17),\
"classification"=>2,\
"grade"=>1,\
"faculty"=>1,\
"address"=>"元田中"\
})


Experiment.connection.execute("DELETE FROM `#{Experiment.table_name}`;")
Experiment.create({\
"member_id"=>1,\
"zisshi_ukagai_date"=>Date.new(2017, 2, 18),\
"project_owner"=>"主",\
"place"=>"あそこ",\
"budget"=>"あの金",\
"department_code"=>"12345",\
"project_num"=>"123",\
"project_name"=>"あのプロジェクト",\
"creditor_code"=>"98765",\
"expected_participant_count"=>20,\
"duration"=>2,\
"name"=>"ほげ実験",\
"description"=>"あれをこうしてそうする。",\
"schedule_from"=>Date.new(2017, 2, 20),\
"schedule_to"=>Date.new(2017, 2, 26),\
"final_report_date"=>Date.new(2017, 2, 28)\
})

Experiment.create({\
"member_id"=>2,\
"zisshi_ukagai_date"=>Date.new(2017, 2, 17),\
"project_owner"=>"主2",\
"place"=>"ここ",\
"budget"=>"この金",\
"department_code"=>"23456",\
"project_num"=>"234",\
"project_name"=>"このプロジェクト",\
"creditor_code"=>"87654",\
"expected_participant_count"=>19,\
"duration"=>1,\
"name"=>"ふが実験",\
"description"=>"それをああしてこうする。",\
"schedule_from"=>Date.new(2017, 2, 18),\
"schedule_to"=>Date.new(2017, 2, 24),\
"final_report_date"=>Date.new(2017, 2, 25)\
})

Experiment.create({\
"member_id"=>2,\
"zisshi_ukagai_date"=>Date.new(2017, 1, 17),\
"project_owner"=>"主",\
"place"=>"ここ",\
"budget"=>"この金",\
"department_code"=>"23456",\
"project_num"=>"234",\
"project_name"=>"あのプロジェクト",\
"creditor_code"=>"98765",\
"expected_participant_count"=>20,\
"duration"=>1,\
"name"=>"ぴよ実験",\
"description"=>"ほげほげげー。",\
"schedule_from"=>Date.new(2017, 1, 18),\
"schedule_to"=>Date.new(2017, 1, 24),\
"final_report_date"=>Date.new(2017, 1, 25)\
})

Schedule.connection.execute("DELETE FROM `#{Schedule.table_name}`;")
Schedule.create({\
"experiment_id"=>1,\
"participant_id"=>1,\
"datetime"=>DateTime.new(2017, 2, 24, 13, 00, 00)\
})
Schedule.create({\
"experiment_id"=>2,\
"participant_id"=>1,\
"datetime"=>DateTime.new(2017, 2, 18, 13, 00, 00)\
})
Schedule.create({\
"experiment_id"=>2,\
"participant_id"=>2,\
"datetime"=>DateTime.new(2017, 2, 24, 15, 00, 00)\
})
Schedule.create({\
"experiment_id"=>3,\
"participant_id"=>3,\
"datetime"=>DateTime.new(2017, 1, 18, 13, 00, 00)\
})