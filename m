Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE82B7C4120
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Oct 2023 22:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbjJJU0e (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Oct 2023 16:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234480AbjJJU0a (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Oct 2023 16:26:30 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BEBFED
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:26:25 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-5a7d9d357faso3761087b3.0
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1696969584; x=1697574384; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M2VMrA1lI9Q4ecQ5bc5FJJXlOR+SulDDfBaPoTgzRVE=;
        b=qHBR6KTb5/EJuFj244Q9gGY7llosCXyLMr2HggcN28lQ3AiDdEmQBmvamMx0L9EWab
         Q22kpdWE66SlTK4XB3BSpR4VJ+ZSK8o+M5eBt3CkUiUkBSCl++aKLcjXKn0V27HfOtEi
         64iW+31QJBmLQU2rMTzlCG6SReVYQE6euKGQX8i2eY3Q761eOhNIb0cBq7cq8XnkSNny
         wY+0XYkR4jBKc3v1PbzhvG3ALHj4SMKMlAIYEWEKxi/9Vt99dZEH5v1/lFrxDKIBFQnh
         7INt3Di28T44YPz6KtnjlD9Z2UuRWa+vAp3s7Q3w81wRl4FrhVG32moGy6uUqsrzmdhQ
         X/Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696969584; x=1697574384;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M2VMrA1lI9Q4ecQ5bc5FJJXlOR+SulDDfBaPoTgzRVE=;
        b=aMJ7K+8M4GzKSvsWUZwwqW8C7M01+EwgjO5IWt38NDZEaE5flqwYW/PCvV4C5D1y+M
         h06q5gj3bYDwxvp1zhKY6BEum20OakarurDDnroQYBo10fI3jKvyVYHkOi8AWDbvnxMj
         at7ftBFjHKfmHfWjM+azvwmns7lfaOvlNMyXAmwcHdAgWFya5tXOnBa9bs4WOJLakxOa
         oMBPi5IbrC8T3H/EaUZaqsn0mM5+hE1YNHRobv2zMRNRuvT0MUr0GLgXZ5dM9qOoftsj
         HdcTut8NmyWRRKWl6OaNmVT/lDbXzsmKo7WvKnFUARAiUr7zeKsVWFiNez9oZjulTOmv
         gPkA==
X-Gm-Message-State: AOJu0YyrOYtj+SiyNRISG5kdwL7rKDfEgty1eAcCtwlLCyzg9x7h2wCV
        cRGOyvqNP1viQTDe66T18ZLETED4tYgKZX26/L1TMQ==
X-Google-Smtp-Source: AGHT+IG+BJZqKItphUjRYVNLo/YE1loYz+1+fzWvZ+O4HVoM+QGspAsPD6MkeRRtOJichHcdzorz5g==
X-Received: by 2002:a0d:ef43:0:b0:595:be7:a38 with SMTP id y64-20020a0def43000000b005950be70a38mr20627894ywe.49.1696969584182;
        Tue, 10 Oct 2023 13:26:24 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id i84-20020a819157000000b005a7bfec6c34sm701856ywg.46.2023.10.10.13.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 13:26:23 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 06/12] btrfs: add simple test of reflink of encrypted data
Date:   Tue, 10 Oct 2023 16:25:59 -0400
Message-ID: <723b5972c3d2d917acc23bf65eb3a5e5feba5ecc.1696969376.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1696969376.git.josef@toxicpanda.com>
References: <cover.1696969376.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

Make sure that we succeed at reflinking encrypted data.

Test deliberately numbered with a high number so it won't conflict with
tests between now and merge.
---
 tests/btrfs/613     | 59 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/613.out | 13 ++++++++++
 2 files changed, 72 insertions(+)
 create mode 100755 tests/btrfs/613
 create mode 100644 tests/btrfs/613.out

diff --git a/tests/btrfs/613 b/tests/btrfs/613
new file mode 100755
index 00000000..0288016e
--- /dev/null
+++ b/tests/btrfs/613
@@ -0,0 +1,59 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023 Meta Platforms, Inc.  All Rights Reserved.
+#
+# FS QA Test 613
+#
+# Check if reflinking one encrypted file on btrfs succeeds.
+#
+. ./common/preamble
+_begin_fstest auto encrypt
+
+# Import common functions.
+. ./common/encrypt
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs btrfs
+
+_require_test
+_require_scratch
+_require_cp_reflink
+_require_scratch_encryption -v 2
+_require_command "$KEYCTL_PROG" keyctl
+
+_scratch_mkfs_encrypted &>> $seqres.full
+_scratch_mount
+
+dir=$SCRATCH_MNT/dir
+mkdir $dir
+_set_encpolicy $dir $TEST_KEY_IDENTIFIER
+_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY"
+echo "Creating and reflinking a file"
+$XFS_IO_PROG -t -f -c "pwrite 0 33k" $dir/test > /dev/null
+cp --reflink=always $dir/test $dir/test2
+
+echo "Can't reflink encrypted and unencrypted"
+cp --reflink=always $dir/test $SCRATCH_MNT/fail |& _filter_scratch
+
+echo "Diffing the file and its copy"
+diff $dir/test $dir/test2
+
+echo "Verifying the files are reflinked"
+_verify_reflink $dir/test $dir/test2
+
+echo "Diffing the files after remount"
+_scratch_cycle_mount
+_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY"
+diff $dir/test $dir/test2
+
+echo "Diffing the files after key remove"
+_rm_enckey $SCRATCH_MNT $TEST_KEY_IDENTIFIER
+diff $dir/test $dir/test2 |& _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/613.out b/tests/btrfs/613.out
new file mode 100644
index 00000000..4895d6dd
--- /dev/null
+++ b/tests/btrfs/613.out
@@ -0,0 +1,13 @@
+QA output created by 613
+Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
+Creating and reflinking a file
+Can't reflink encrypted and unencrypted
+cp: failed to clone 'SCRATCH_MNT/fail' from 'SCRATCH_MNT/dir/test': Invalid argument
+Diffing the file and its copy
+Verifying the files are reflinked
+Diffing the files after remount
+Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
+Diffing the files after key remove
+Removed encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
+diff: SCRATCH_MNT/dir/test: No such file or directory
+diff: SCRATCH_MNT/dir/test2: No such file or directory
-- 
2.41.0

