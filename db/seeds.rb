Member.delete_all
Member.create!([
  { name: "太郎",
    yomi: "たろう",
    email: "taro@ii.ist.i.kyoto-u.ac.jp",
    password: 'password',
    password_confirmation: 'password',
    admin: false,
  },
  { name: "アドミン",
    yomi: "あどみん",
    email: "admin@i.kyoto-u.ac.jp",
    password: 'password',
    password_confirmation: 'password',
    admin: true,
    activated: true,
  },
])

Faculty.delete_all
Faculty.create!([
  { name: "工学部",
    classification: 1,
  },
  { name: "理学部",
    classification: 1,
  },
  { name: "情報学研究科",
    classification: 2,
  },
])

Participant.delete_all
faculties = Faculty.all
Participant.create!([
  { email: "test@example.com",
    password: 'password',
    password_confirmation: 'password',
    name: "手酢都",
    yomi: "てすと",
    gender: 1,
    birth: Date.new(1995, 12, 18),
    classification: 1,
    grade: 3,
    faculty_id: faculties[0].id,
    address: "百万遍",
    activated: true,
    activated_at: DateTime.now,
  },
  { email: "satoshi@b.c",
    password: 'password',
    password_confirmation: 'password',
    name: "悟志",
    yomi: "さとし",
    gender: 1,
    birth: Date.new(1993, 6, 8),
    classification: 2,
    grade: 1,
    faculty_id: faculties[1].id,
    address: "出町柳",
    activated: true,
    activated_at: DateTime.now,
  },
  { email: "rika@b.c",
    password: 'password',
    password_confirmation: 'password',
    name: "梨花",
    yomi: "りか",
    gender: 2,
    birth: Date.new(1991, 9, 17),
    classification: 2,
    grade: 1,
    faculty_id: faculties[2].id,
    address: "元田中",
    activated: true,
    activated_at: DateTime.now,
  },
  { email: "rena@b.c",
    password: 'password',
    password_confirmation: 'password',
    name: "レナ",
    yomi: "れな",
    gender: 2,
    birth: Date.new(1991, 9, 17),
    classification: 2,
    grade: 1,
    faculty_id: faculties[2].id,
    address: "元田中",
    activated: true,
    activated_at: DateTime.now,
  },
])

Room.delete_all
Room.create!([
    { name: '総合研究7号館207号室',
    },
    { name: '総合研究7号館217号室',
    },
    { name: '3号館B棟',
    },
    { name: '時計台前',
    },
    { name: '総合研究7号館215号室',
    },
])

Place.delete_all
rooms = Room.all
Place.create!([
    { room_id: rooms[0].id,
      detail:  'ICIE 1'
    },
    { room_id: rooms[1].id,
      detail:  'ICIE 2'
    },
    { room_id: rooms[2].id,
      detail:  'ドームディスプレイ'
    },
    { room_id: rooms[0].id,
      detail:  ''
    },
    { room_id: rooms[3].id,
      detail:  ''
    },
    { room_id: rooms[4].id,
      detail:  ''
    },
])

Experiment.delete_all
members = Member.all
Experiment.create!([
  { member_id: members[0].id,
    zisshi_ukagai_date: Date.new(2017, 2, 18),
    project_owner: "主",
    room_id: rooms[0].id,
    budget: "あの金",
    department_code: "12345",
    project_num: "123",
    project_name: "あのプロジェクト",
    creditor_code: "98765",
    expected_participant_count: 20,
    duration: 120,
    name: "ほげ実験",
    description: "あれをこうしてそうする。",
    requirement: "特になし",
    schedule_from: Date.new(2017, 2, 20),
    schedule_to: Date.new(2017, 2, 26),
    final_report_date: Date.new(2017, 2, 28)
  },
  { member_id: members[1].id,
    zisshi_ukagai_date: Date.new(2017, 2, 17),
    project_owner: "主2",
    room_id: rooms[1].id,
    budget: "この金",
    department_code: "23456",
    project_num: "234",
    project_name: "このプロジェクト",
    creditor_code: "87654",
    expected_participant_count: 19,
    duration: 60,
    name: "ふが実験",
    description: "それをああしてこうする。",
    requirement: "・女性\n・外国人学生",
    schedule_from: Date.new(2017, 2, 18),
    schedule_to: Date.new(2017, 2, 24),
    final_report_date: Date.new(2017, 2, 25)
  },
  { member_id: members[1].id,
    zisshi_ukagai_date: Date.new(2017, 1, 17),
    project_owner: "主",
    room_id: rooms[3].id,
    budget: "この金",
    department_code: "23456",
    project_num: "234",
    project_name: "このプロジェクト",
    creditor_code: "98765",
    expected_participant_count: 20,
    duration: 60,
    name: "ぴよ実験",
    description: "ほげほげげー。",
    requirement: "・男性\n・日本人学生",
    schedule_from: Date.new(2017, 1, 18),
    schedule_to: Date.new(2017, 1, 24),
    final_report_date: Date.new(2017, 1, 25)
  },
])

Schedule.delete_all
experiments = Experiment.all
Schedule.create!([
  { experiment_id: experiments[0].id,
    datetime: DateTime.new(2017, 2, 24, 13, 0, 0, "+0900"),
  },
  { experiment_id: experiments[1].id,
    datetime: DateTime.new(2017, 2, 26, 15, 0, 0, "+0900"),
  },
  { experiment_id: experiments[1].id,
    datetime: DateTime.new(2017, 2, 27, 9, 0, 0, "+0900"),
  },
  { experiment_id: experiments[2].id,
    datetime: DateTime.new(2017, 1, 27, 9, 0, 0, "+0900"),
  },
  { experiment_id: experiments[1].id,
    datetime: DateTime.new(2017, 2, 25, 10, 0, 0, "+0900"),
  },
])

Application.delete_all
participants = Participant.all
schedules = Schedule.all
Application.create!([
   { participant_id: participants[0].id,
     schedule_id: schedules[0].id,
     status: 0,
   },
   { participant_id: participants[1].id,
     schedule_id: schedules[1].id,
     status: 1,
   },
   { participant_id: participants[2].id,
     schedule_id: schedules[2].id,
     status: 0,
   },
   { participant_id: participants[0].id,
     schedule_id: schedules[2].id,
     status: 0,
   },
   { participant_id: participants[3].id,
     schedule_id: schedules[3].id,
     status: 0,
   },
])

Inquiry.delete_all
Inquiry.create!([
    { subject: '実験についての質問',
      body: 'この実験は楽しいですか？',
      unread: true,
      participant_id: participants[0].id,
      experiment_id: experiments[0].id,
    },
])

Event.delete_all
Event.create!([
    { name: '事前手続き',
      requirement: '印鑑(シャチハタは不可)',
      description: '事前手続きです。',
      place: '総合研究7号館207号室',
      start_at: DateTime.new(2017, 2, 24, 11, 0, 0, "+0900"),
      duration: 10,
      participant_id: participants[0].id,
      experiment_id: experiments[0].id,
    },
])
