Return-Path: <linux-fscrypt+bounces-1073-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6IqXLEcId2lGawEAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1073-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Mon, 26 Jan 2026 07:23:03 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1010784754
	for <lists+linux-fscrypt@lfdr.de>; Mon, 26 Jan 2026 07:23:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 74892300E3B4
	for <lists+linux-fscrypt@lfdr.de>; Mon, 26 Jan 2026 06:22:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D2EE26F291;
	Mon, 26 Jan 2026 06:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iIZJLCpi"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFEB26ED56
	for <linux-fscrypt@vger.kernel.org>; Mon, 26 Jan 2026 06:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769408547; cv=none; b=LLUUqPNxhAviTH3hDV0gwCxZMF5giuTByRv36BIWc6Z2ad1eucCNUp8OcpvGAXTEoW7RxR1SMmERHZjO8eZ0NnwxOXtPH1mnJjungRa0nzbAzQ1mmH+VdkOuRHWmcDd2sHWfx9cpgZtR0SS5jjpo+J3qPHjfwicy9AJ6QrgEFJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769408547; c=relaxed/simple;
	bh=wVcEOabu+MmwmowSbMTRHRC+lG0AOAc8Wi9xyK5hGFI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JX/2aCmybSl94aCvIeiWKSOs97yL6N9TTz3IZs5zp+37JTuVzwryhY0dd0IwvFm3ODguWaFUaNbRj4f+oJi/uFia3HFRnVPoneXlp0a3qAZrCOMAhnESSJeMthV8ivvIEQp/VF++Y+ebunO+Q96PHcWW5J2SQ991W2yl5XywlwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iIZJLCpi; arc=none smtp.client-ip=209.85.214.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-29f102b013fso38063525ad.2
        for <linux-fscrypt@vger.kernel.org>; Sun, 25 Jan 2026 22:22:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769408545; x=1770013345; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VKxqszDPuAvDzbRmbLp7U/ja3AVfp5yy/5Nf+0NiEmo=;
        b=iIZJLCpis3OgdVXtsBgHi5rnxHixrF/OwbKsdFCjsp+HqUi2oQ9RE/gdVhBgIkB1le
         +ehYLTuCfVzR3PxlmHStWlsDrKxYvq7pzYZ3aK6V4MrwdgXCUnCskxa4tPiGgd0Kt4X9
         BZiSwg2g9Aoh1xCoDWSQTmQr7C1YPSgrOz7Al9ECnEY+sov3M9hvrpn/OLarqHQUBmaZ
         FubwfAu+W1rO2gjJQNTeYxFZHEAsli14DkrKyAJgBPvpuTx5T8tydBTZztZjSVMBpeFs
         7Grk8qNjIxBzx+gCWg1TFef6VUPPWk2gb7CDt+5BnZlBLuX2TQfTJoAQS64EpKFHL84y
         cuOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769408545; x=1770013345;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VKxqszDPuAvDzbRmbLp7U/ja3AVfp5yy/5Nf+0NiEmo=;
        b=Fjkc5k2Juz4iddfgYrSd1yZg9hmAbdgFwhwyZ9VW2MjnL1frXsoibNvyq19fUApdbM
         g5C1G/bjpciVSUEkX5Z1hqWBfbjTYBNJG7w/ZyV2P+02CerWDkBdZEb0/EQxgo6fUFsl
         AcbF6YPclHYDsLvFDVBsvh0gFKHBZfeZiYcD1HQzw2/T1pd+aWlrFiUWSrqGqeEm3U78
         fpK0gdpzQajY4itcLzaUpd/nDCkZiKmGz1wEffiPWH3Tw8po30YM/MuPegZ9F/3ARdPu
         9Vp3ooEBTXj1rqOeFc2x4UQmd0vGMMGY1HOo0bP9yaDk/Jpy/duxzwXdyhnIIcCqa92d
         jQyA==
X-Forwarded-Encrypted: i=1; AJvYcCWA6VwemeHLEVn9AH4VcKUb/itbDwBN9GAul5x0LvUF71zre2P84yGbH0jL0UZs4gGb2tV9Gv9XybC2DCrM@vger.kernel.org
X-Gm-Message-State: AOJu0YxC9yuQNXobjt3McK/51aMxaUxLYRnG/cUrc139bOD9ZFM31YcY
	N4qgQeM8jizAPe6xjFOGPMggsebK4GIMWMY8/lntkzHP5xCM3CVYaLwz
X-Gm-Gg: AZuq6aJJJ+tkY6EcUkSpURsZyjgQGuqqu7wTxobSfxvuHObBMgRIsCYuQnD8Gt/G05f
	z7XBJNaRAtkTW5KsOG43fFbxAKJFvXM8eYEWYdcGCfAo/PkmAiimTmN6Src1/7X1Lj18KgLKjxF
	GSGuQUH4FebGC+TCQmDhWxo6ETxfVvHKWygHtQGdIuzfjbW+f6DJUubO0qHhY9BAsa6A/ZJw7c2
	XyNNg75JePTQsjx/jVL2El394QjLSZXgMaFz0fs64e2phdjpJq/T1rR9omWs4onOVb8KqX9fQhN
	3l6yCcEjpVD5I+c/IFhnZ+7DlhPm7cE5yW/wtE12bVQ7gBD6/194ammNPFEH5Tdv+V5m+/ETRbt
	WLSgEWqkgwJn2zM67Bw7K8wViXFZoAad09HbiTCyu6qZXbMgsT7IXKkziucy6vE06ybw57iMtSD
	PX8jjp9b3IsPLGwtBZ7N2DQ+2SUIr6SvdCteMrH/0XqWC/U5jG
X-Received: by 2002:a17:902:e84f:b0:2a2:f0cb:df9e with SMTP id d9443c01a7336-2a84523fb39mr33207305ad.1.1769408545494;
        Sun, 25 Jan 2026 22:22:25 -0800 (PST)
Received: from lima-ubuntu.hz.ali.com ([47.246.98.220])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802fada7fsm81900965ad.68.2026.01.25.22.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jan 2026 22:22:24 -0800 (PST)
From: Qing Wang <wangqing7171@gmail.com>
To: ebiggers@kernel.org
Cc: jaegeuk@kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+d130f98b2c265fae5297@syzkaller.appspotmail.com,
	tytso@mit.edu,
	wangqing7171@gmail.com
Subject: [PATCH v2] fscrypt: Fix uninit-value in ovl_fill_real
Date: Mon, 26 Jan 2026 14:22:16 +0800
Message-Id: <20260126062216.496560-1-wangqing7171@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260124182547.GA2762@quark>
References: <20260124182547.GA2762@quark>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1073-lists,linux-fscrypt=lfdr.de];
	FREEMAIL_CC(0.00)[kernel.org,vger.kernel.org,syzkaller.appspotmail.com,mit.edu,gmail.com];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[wangqing7171@gmail.com,linux-fscrypt@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[linux-fscrypt,d130f98b2c265fae5297];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,appspotmail.com:email,syzkaller.appspot.com:url]
X-Rspamd-Queue-Id: 1010784754
X-Rspamd-Action: no action

Syzbot reported a KMSAN uninit-value issue in ovl_fill_real.

This iusse's call chain is:
__do_sys_getdents64()
    -> iterate_dir()
        ...
            -> ext4_readdir()
                -> fscrypt_fname_alloc_buffer() // alloc
                -> fscrypt_fname_disk_to_usr // write without tail '\0'
                -> dir_emit()
                    -> ovl_fill_real() // read by strcmp()

The string is used to store the decrypted directory entry name for an
encrypted inode. As shown in the call chain, fscrypt_fname_disk_to_usr()
write it wthout null-terminate. However, ovl_fill_real() uses strcmp() to
compare the name against "..", which assumes a null-terminated string and
may trigger a KMSAN uninit-value warning when the buffer tail contains
uninit data.

Reported-by: syzbot+d130f98b2c265fae5297@syzkaller.appspotmail.com
Fixes: 4edb83bb1041 ("ovl: constant d_ino for non-merge dirs")
Closes: https://syzkaller.appspot.com/bug?extid=d130f98b2c265fae5297
Signed-off-by: Qing Wang <wangqing7171@gmail.com>
---
 fs/overlayfs/readdir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 160960bb0ad0..e852b38949b6 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -755,7 +755,7 @@ static bool ovl_fill_real(struct dir_context *ctx, const char *name,
 	struct dir_context *orig_ctx = rdt->orig_ctx;
 	bool res;
 
-	if (rdt->parent_ino && strcmp(name, "..") == 0) {
+	if (rdt->parent_ino && namelen == 2 && strncmp(name, "..", namelen) == 0) {
 		ino = rdt->parent_ino;
 	} else if (rdt->cache) {
 		struct ovl_cache_entry *p;
-- 
2.34.1


