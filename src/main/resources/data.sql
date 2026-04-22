INSERT INTO xz_hot_question (position, tag, content, views, favorites, practices)
SELECT 'Java鍚庣宸ョ▼甯?, 'Redis', '缂撳瓨绌块€忋€佺紦瀛樺嚮绌裤€佺紦瀛橀洩宕╁垎鍒槸浠€涔堬紵濡備綍缁勫悎娌荤悊锛?, 10, 2, 3
WHERE NOT EXISTS (
    SELECT 1 FROM xz_hot_question
    WHERE position = 'Java鍚庣宸ョ▼甯? AND tag = 'Redis' AND content = '缂撳瓨绌块€忋€佺紦瀛樺嚮绌裤€佺紦瀛橀洩宕╁垎鍒槸浠€涔堬紵濡備綍缁勫悎娌荤悊锛?
);

INSERT INTO xz_hot_question (position, tag, content, views, favorites, practices)
SELECT 'Java鍚庣宸ョ▼甯?, 'MySQL', 'Explain 鎵ц璁″垝閲?type=ref 鍜?type=range 鐨勫樊寮傛槸浠€涔堬紵', 10, 2, 3
WHERE NOT EXISTS (
    SELECT 1 FROM xz_hot_question
    WHERE position = 'Java鍚庣宸ョ▼甯? AND tag = 'MySQL' AND content = 'Explain 鎵ц璁″垝閲?type=ref 鍜?type=range 鐨勫樊寮傛槸浠€涔堬紵'
);

INSERT INTO xz_hot_question (position, tag, content, views, favorites, practices)
SELECT 'Java鍚庣宸ョ▼甯?, 'JVM', '绾夸笂 Full GC 棰戠箒锛屼綘浼氭寜浠€涔堥『搴忔帓鏌ワ紵', 10, 2, 3
WHERE NOT EXISTS (
    SELECT 1 FROM xz_hot_question
    WHERE position = 'Java鍚庣宸ョ▼甯? AND tag = 'JVM' AND content = '绾夸笂 Full GC 棰戠箒锛屼綘浼氭寜浠€涔堥『搴忔帓鏌ワ紵'
);

INSERT INTO xz_hot_question (position, tag, content, views, favorites, practices)
SELECT 'Java鍚庣宸ョ▼甯?, 'Spring', 'Spring 浜嬪姟澶辨晥鐨勫父瑙佸満鏅湁鍝簺锛?, 10, 2, 3
WHERE NOT EXISTS (
    SELECT 1 FROM xz_hot_question
    WHERE position = 'Java鍚庣宸ョ▼甯? AND tag = 'Spring' AND content = 'Spring 浜嬪姟澶辨晥鐨勫父瑙佸満鏅湁鍝簺锛?
);

INSERT INTO xz_hot_question (position, tag, content, views, favorites, practices)
SELECT 'Java鍚庣宸ョ▼甯?, '椤圭洰缁忛獙', '鎻忚堪涓€娆′綘鍋氳繃鐨勯珮骞跺彂浼樺寲锛屾寚鏍囧墠鍚庡彉鍖栧浣曪紵', 10, 2, 3
WHERE NOT EXISTS (
    SELECT 1 FROM xz_hot_question
    WHERE position = 'Java鍚庣宸ョ▼甯? AND tag = '椤圭洰缁忛獙' AND content = '鎻忚堪涓€娆′綘鍋氳繃鐨勯珮骞跺彂浼樺寲锛屾寚鏍囧墠鍚庡彉鍖栧浣曪紵'
);

INSERT INTO xz_prompt_template (module, name, content, updated_at)
SELECT 'resume-parse', '绠€鍘嗚В鏋?Prompt', '鎻愬彇鎶€鑳姐€侀」鐩粡鍘嗐€佹暀鑲茶儗鏅€佸彲杩介棶鐐癸紝杈撳嚭缁撴瀯鍖?JSON銆?, DATE_SUB(NOW(), INTERVAL 1 DAY)
WHERE NOT EXISTS (SELECT 1 FROM xz_prompt_template WHERE module = 'resume-parse');

INSERT INTO xz_prompt_template (module, name, content, updated_at)
SELECT 'jd-analyze', 'JD 鍒嗘瀽 Prompt', '浠庡矖浣嶆弿杩颁腑鎻愬彇鏍稿績鎶€鑳姐€佸叧閿瘝銆侀潰璇曞叧娉ㄧ偣鍜岃ˉ寮哄缓璁€?, DATE_SUB(NOW(), INTERVAL 1 DAY)
WHERE NOT EXISTS (SELECT 1 FROM xz_prompt_template WHERE module = 'jd-analyze');

INSERT INTO xz_prompt_template (module, name, content, updated_at)
SELECT 'question-generate', '棰樼洰鐢熸垚 Prompt', '鎸夐」鐩繁鎸栥€丷edis銆丮ySQL銆佸苟鍙戙€丼pring 鐢熸垚涓珮绾ч棶棰樸€?, DATE_SUB(NOW(), INTERVAL 1 DAY)
WHERE NOT EXISTS (SELECT 1 FROM xz_prompt_template WHERE module = 'question-generate');

INSERT INTO xz_prompt_template (module, name, content, updated_at)
SELECT 'answer-score', '鍥炵瓟璇勫垎 Prompt', '浠庢纭€с€佸畬鏁存€с€佹潯鐞嗘€с€佽〃杈俱€佹妧鏈繁搴﹁瘎鍒嗗苟缁欐敼杩涘缓璁€?, DATE_SUB(NOW(), INTERVAL 1 DAY)
WHERE NOT EXISTS (SELECT 1 FROM xz_prompt_template WHERE module = 'answer-score');

INSERT INTO xz_prompt_template (module, name, content, updated_at)
SELECT 'interview-follow-up', '杩介棶鐢熸垚 Prompt', '鍩轰簬褰撳墠闂涓庣敤鎴峰洖绛旂敓鎴愪竴鏉￠珮璐ㄩ噺杩介棶锛岃姹傚叿浣撱€佸彲娣辨寲銆佸彲璇勪及銆?, DATE_SUB(NOW(), INTERVAL 1 DAY)
WHERE NOT EXISTS (SELECT 1 FROM xz_prompt_template WHERE module = 'interview-follow-up');

INSERT INTO xz_prompt_template (module, name, content, updated_at)
SELECT 'report-generate', '鎶ュ憡鐢熸垚 Prompt', '鏍规嵁鏁村満闂瓟鐢熸垚澶嶇洏鎶ュ憡锛屽寘鍚己寮辩偣銆佸涔犺矾绾垮拰鏍囧噯琛ㄨ揪銆?, DATE_SUB(NOW(), INTERVAL 1 DAY)
WHERE NOT EXISTS (SELECT 1 FROM xz_prompt_template WHERE module = 'report-generate');

INSERT INTO xz_risk_config (
    id,
    rate_limit_per_minute,
    max_question_generate_per_day,
    max_report_generate_per_day,
    upload_max_mb,
    upload_allow_types,
    input_max_length,
    prompt_injection_check,
    output_safety_check,
    idempotency_check
) VALUES (1, 10, 50, 5, 10, 'pdf,doc,docx', 20000, 1, 1, 1)
ON DUPLICATE KEY UPDATE id = id;

INSERT IGNORE INTO xz_sensitive_word (word, enabled, created_at)
VALUES
    ('杩濇硶鍐呭', 1, DATE_SUB(NOW(), INTERVAL 10 DAY)),
    ('浠囨仺瑷€璁?, 1, DATE_SUB(NOW(), INTERVAL 5 DAY));
