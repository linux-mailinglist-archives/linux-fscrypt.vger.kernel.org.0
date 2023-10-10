Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB9757C412C
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Oct 2023 22:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbjJJU0o (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Oct 2023 16:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234539AbjJJU0a (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Oct 2023 16:26:30 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91B6101
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:26:26 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-5a4c073cc06so2077587b3.1
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1696969586; x=1697574386; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3hzSgDT0gSoCBX2kCWh7EzeVvXJNhVaEv2jbeDNylHU=;
        b=PaIPiU64zkb7shF8XRz5d7OP0jz+m0uJYV++VIBdawswqF3loG3st5JpPf+xDoUJKM
         66MzEdLcFWPwpn47x0icvbvOqIBDA1TamkiVxOvbAuZa0l21Zxf2rUelb7RrBgV50Ida
         MK8+dEpvUwQqTX+ccyIbk7UTpE9AU8SEClXuVxw8Lxms3HEZ6S3gvy4kkApZ/CBrd+8E
         6xWfUakK303goQePALyJDI+rKT54jpThCrZmEZe/8MLXkG96voVKd2KiyIDD/vvCOCH5
         URE3EMTDt3VhuMw7qziw1U5pwMxf0V94lzmnEcYd8Z1fsIjNbZaCIORdc9MwQFQ95JM3
         s5kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696969586; x=1697574386;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3hzSgDT0gSoCBX2kCWh7EzeVvXJNhVaEv2jbeDNylHU=;
        b=i5ohLK2sbbGiSBPU/FuWQZHEV4OaboDJCnp0bzRs5iNQHCqxbVBwAHrcef8z3Lzges
         9gjcNVt3PJlnS5RwEREvJmumeognZiPxbTpVJ/cmzcICRv8y4urTxjd1vE8Mtteo0yzb
         YfNdLDpKK+RuZjJRJ19CoyPdDlkjF9gL6iaRoPvz+IifyeTSZFrDvRg9GcwQmuWhTDvn
         m6bVVHe6kzEeN8UJ7DyFH0SiJkJ6mTnXpFZoNhT3U0KVshek4d/s/TZf89kPn6lgpQF4
         Iz9HPgSm7K60ctocOdx/tbCi5GomnG89YhcrF/Fmu6xniVL/ACCI3ngjJ/nakbs7EDO3
         xvCA==
X-Gm-Message-State: AOJu0YwlGlfXxSKlhvFuJOT9GtZnBBNCXyzvcyLXPLCja+vdGl3019bg
        QQEkRS6la1M+3VwPWJF0xhcBCEOzxx2unhv1Y/lgsg==
X-Google-Smtp-Source: AGHT+IEADGedsJ+tD+z1v+BkL/Fj36MMKWHXc5DgD5MLY74OYK5q9bScHx6p5oY7kR3DiomxEx51DA==
X-Received: by 2002:a81:4e10:0:b0:56c:e480:2b2b with SMTP id c16-20020a814e10000000b0056ce4802b2bmr10786812ywb.12.1696969585964;
        Tue, 10 Oct 2023 13:26:25 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id p20-20020a0de614000000b005a7bbd713ddsm824658ywe.108.2023.10.10.13.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 13:26:25 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 08/12] fstests: properly test for v1 encryption policies in encrypt tests
Date:   Tue, 10 Oct 2023 16:26:01 -0400
Message-ID: <c77a1a8ca09b2738f432d586177801a579a775e4.1696969376.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1696969376.git.josef@toxicpanda.com>
References: <cover.1696969376.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

With btrfs adding fscrypt support we're limiting the usage to plain v2
policies only.  This means we need to update the _require's for
generic/593 that tests both v1 and v2 policies.  The other sort of tests
will be split into two tests in later patches.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 common/encrypt    | 2 ++
 tests/generic/593 | 1 +
 2 files changed, 3 insertions(+)

diff --git a/common/encrypt b/common/encrypt
index 1372af66..120ca612 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -59,6 +59,8 @@ _require_scratch_encryption()
 	# policy required by the test.
 	if [ $# -ne 0 ]; then
 		_require_encryption_policy_support $SCRATCH_MNT "$@"
+	else
+		_require_encryption_policy_support $SCRATCH_MNT -v 1
 	fi
 
 	_scratch_unmount
diff --git a/tests/generic/593 b/tests/generic/593
index 2dda5d76..7907236c 100755
--- a/tests/generic/593
+++ b/tests/generic/593
@@ -17,6 +17,7 @@ _begin_fstest auto quick encrypt
 
 # real QA test starts here
 _supported_fs generic
+_require_scratch_encryption -v 1
 _require_scratch_encryption -v 2
 _require_command "$KEYCTL_PROG" keyctl
 
-- 
2.41.0

