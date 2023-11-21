Return-Path: <linux-fscrypt+bounces-11-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA7837F398F
	for <lists+linux-fscrypt@lfdr.de>; Tue, 21 Nov 2023 23:57:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 221791C208CF
	for <lists+linux-fscrypt@lfdr.de>; Tue, 21 Nov 2023 22:57:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8067A54BE3;
	Tue, 21 Nov 2023 22:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JEu6w1af"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D52719E;
	Tue, 21 Nov 2023 14:56:54 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1cc938f9612so40361575ad.1;
        Tue, 21 Nov 2023 14:56:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700607414; x=1701212214; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wo5dqey6I8QbyZ6Fam9wAbARY07XFw/XeE4bQ28EgY0=;
        b=JEu6w1afdz8Hu27VUzP9Khj5RCJ7GpOn5dgugyME5UtqgJd2CWujQuZ+EBBOuckNKF
         QvgxGntVtrFXpj6dJYcGudmkYF7SJtSqrGw14OZDUaA+9Etc5ULDYPgb8IEOcM51TbZy
         XPJeL6dwoJ544kri/7bWwEvT3aGTz4rgGh4/BRKH+3cHkReS/uLoiGWtY8ko6PRrQDTg
         gqqKDQd8dvJF+vSKQ9aL31kQ0VcZAVnYOE7Od0bbi7u7eZ+u8LaM5QYecIWcToNcfDeX
         /MmOj9MYiLbkT9jUGoEfA/DTAqhL3LYuL4GvPZ0c6dFLsqz2nA/SJyb51h4+p/um4jSa
         23zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700607414; x=1701212214;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wo5dqey6I8QbyZ6Fam9wAbARY07XFw/XeE4bQ28EgY0=;
        b=SrDFeAc14cxHFbXaGUWCGLXAMpztgZuzzyJdt9jQtxGHdE1d8Lizobg5GoEmomvHO2
         gPxXsR5jYNI/ciVB/ojyem6x+WKeSIdZSKNrHqaHD9JJkFsuCTkgUR+e9sdGU2j1JkeD
         HZXSGgkrGVu1RLphm+CPBhLHWAkQnxLKLtKAB0uf48c9v0ViCm4UFKHetqIDnRENLMqL
         6y9qJVkQ3ipHjxkglK0Lu6Oc+DCeWeYETZCo8aKi9NDK6KHvkz99Wj+bimbmt9mOzuIc
         7OuBDCQt1xiJWZHaH0ZIfgjwyWCyugRBvrQDSHVaNda3B7dsNTeBeI7TsQmIVSa3qt6Y
         zzAQ==
X-Gm-Message-State: AOJu0Yx5n0ujhgIBcOtY/lKFIZbQ4n9GyIyi0rvvLV19gZ9GKzj6i6wG
	+oWEE2WdOD4e+MOOMlTCZstkm7X/now=
X-Google-Smtp-Source: AGHT+IGIxq+l3yx4uYvZ5XmfPTWhnQX0FwJnRjQlkZ5Na4RwXZf6doms4MSbaTaFoR61OXOoFguLJQ==
X-Received: by 2002:a17:903:11ce:b0:1cf:66a3:16c with SMTP id q14-20020a17090311ce00b001cf66a3016cmr649997plh.21.1700607413955;
        Tue, 21 Nov 2023 14:56:53 -0800 (PST)
Received: from bangji.hsd1.ca.comcast.net ([2601:647:6780:42e0:7377:923f:1ff3:266d])
        by smtp.gmail.com with ESMTPSA id m12-20020a1709026bcc00b001cc47c1c29csm8413189plt.84.2023.11.21.14.56.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Nov 2023 14:56:53 -0800 (PST)
Sender: Namhyung Kim <namhyung@gmail.com>
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>
Cc: Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-perf-users@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-fscrypt@vger.kernel.org
Subject: [PATCH 02/14] tools headers UAPI: Update tools's copy of fscrypt.h header
Date: Tue, 21 Nov 2023 14:56:37 -0800
Message-ID: <20231121225650.390246-2-namhyung@kernel.org>
X-Mailer: git-send-email 2.43.0.rc1.413.gea7ed67945-goog
In-Reply-To: <20231121225650.390246-1-namhyung@kernel.org>
References: <20231121225650.390246-1-namhyung@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

tldr; Just FYI, I'm carrying this on the perf tools tree.

Full explanation:

There used to be no copies, with tools/ code using kernel headers
directly. From time to time tools/perf/ broke due to legitimate kernel
hacking. At some point Linus complained about such direct usage. Then we
adopted the current model.

The way these headers are used in perf are not restricted to just
including them to compile something.

There are sometimes used in scripts that convert defines into string
tables, etc, so some change may break one of these scripts, or new MSRs
may use some different #define pattern, etc.

E.g.:

  $ ls -1 tools/perf/trace/beauty/*.sh | head -5
  tools/perf/trace/beauty/arch_errno_names.sh
  tools/perf/trace/beauty/drm_ioctl.sh
  tools/perf/trace/beauty/fadvise.sh
  tools/perf/trace/beauty/fsconfig.sh
  tools/perf/trace/beauty/fsmount.sh
  $
  $ tools/perf/trace/beauty/fadvise.sh
  static const char *fadvise_advices[] = {
        [0] = "NORMAL",
        [1] = "RANDOM",
        [2] = "SEQUENTIAL",
        [3] = "WILLNEED",
        [4] = "DONTNEED",
        [5] = "NOREUSE",
  };
  $

The tools/perf/check-headers.sh script, part of the tools/ build
process, points out changes in the original files.

So its important not to touch the copies in tools/ when doing changes in
the original kernel headers, that will be done later, when
check-headers.sh inform about the change to the perf tools hackers.

Cc: Eric Biggers <ebiggers@kernel.org>
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-fscrypt@vger.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/include/uapi/linux/fscrypt.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/include/uapi/linux/fscrypt.h b/tools/include/uapi/linux/fscrypt.h
index fd1fb0d5389d..7a8f4c290187 100644
--- a/tools/include/uapi/linux/fscrypt.h
+++ b/tools/include/uapi/linux/fscrypt.h
@@ -71,7 +71,8 @@ struct fscrypt_policy_v2 {
 	__u8 contents_encryption_mode;
 	__u8 filenames_encryption_mode;
 	__u8 flags;
-	__u8 __reserved[4];
+	__u8 log2_data_unit_size;
+	__u8 __reserved[3];
 	__u8 master_key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
 };
 
-- 
2.43.0.rc1.413.gea7ed67945-goog


