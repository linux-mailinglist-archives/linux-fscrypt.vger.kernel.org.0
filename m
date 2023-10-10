Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29F367C4127
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Oct 2023 22:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234685AbjJJU0j (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Oct 2023 16:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234510AbjJJU0g (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Oct 2023 16:26:36 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEC0AC
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:26:31 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-5a7dafb659cso2272117b3.0
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1696969591; x=1697574391; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TYV6W3/su+yQdVC08/W92yX/IiZTkZ+W2IG1K67YFEE=;
        b=CPK4WauFk1tak6CV4zolZKCy2JoVv3UUf4yWBpQfTiBhaILnk+HeLUugwYR8nYSbVI
         7CeUnXcXyOt4UiHr9lmuNXveqR/1ixvdEdQ3cFbkkf0UuNyp/izAqT/UB/NPkFOcIguz
         8vILIO+nbjucFHTxOfZsG/25fd6saUXsSvFJck9uYp8GK4UaT6wm0XkTXIM+J38m4ViR
         Pbz4H7jfOFBQRuklnOGR7MxR9R5F031vYM1wUTPJgRETZxJHXEZ/N1kole5je1IB9mmA
         db3L87VU5hmk2mnxVBae68d1mJwCPMb73kRE76k9oJdJPZsbogxg7G90Tdssfhg+KIef
         XOBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696969591; x=1697574391;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TYV6W3/su+yQdVC08/W92yX/IiZTkZ+W2IG1K67YFEE=;
        b=OIjaD30QUbxk68QEY/zQ4S1XWfNkv1fRg7fCfvhwgJSr0HLINrUkbmLtB5J02kOfdP
         CCUh6EtdQJuDk1YkLB1Egi8tu6lPrOvJ0N6JDursV6LdlA7S9q/vOL+C2wEy1lyPNZWO
         NHwacJPZg2rZuQ3b+9u09admqy8uirLuOeWGAZE50S21W/dx6wCtslggRa77cZ8YAnoA
         RJ9hBqOCWJY89addI+zoN4I5yD9BcsKg8F5UbkNOXHcXCmIhz29y54E7E965gDj5zTRo
         MIVDqU/EM6L9u/mONHD1jnDtYyAfzqPHDXkBKRCWEWLb4REy75cLZ9fOXa1mZ/vWC9gN
         b/Jg==
X-Gm-Message-State: AOJu0Yzz/2OsQpGVxx0CJfWtpUwBqywqQ233aIthmHGnNZayeZPWcMw3
        vlTOvdsuwBfNr3PKCpp/Ik5SEkX9YpSOAaRuqZ/gjg==
X-Google-Smtp-Source: AGHT+IGvgRhnxM8rs8Q4ccehZoHcRELzxu4LMU2pLr32V5AjQW8wniDsc5M8y0GOBrzOZ5UXLUl+cw==
X-Received: by 2002:a0d:ea90:0:b0:5a1:db12:d782 with SMTP id t138-20020a0dea90000000b005a1db12d782mr19988174ywe.44.1696969590781;
        Tue, 10 Oct 2023 13:26:30 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id c4-20020a81df04000000b0059b1e1b6e5dsm4581610ywn.91.2023.10.10.13.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 13:26:30 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 12/12] fstest: add a fsstress+fscrypt test
Date:   Tue, 10 Oct 2023 16:26:05 -0400
Message-ID: <936037a6c2bcf5553145862c5358e175621983b0.1696969376.git.josef@toxicpanda.com>
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

I noticed we don't run fsstress with fscrypt in any of our tests, and
this was helpful in uncovering a couple of symlink related corner cases
for the btrfs support work.  Add a basic test that creates a encrypted
directory and runs fsstress in that directory.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 tests/generic/736     | 38 ++++++++++++++++++++++++++++++++++++++
 tests/generic/736.out |  3 +++
 2 files changed, 41 insertions(+)
 create mode 100644 tests/generic/736
 create mode 100644 tests/generic/736.out

diff --git a/tests/generic/736 b/tests/generic/736
new file mode 100644
index 00000000..0ef37d7e
--- /dev/null
+++ b/tests/generic/736
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2023 Meta
+#
+# FS QA Test No. generic/5736
+#
+# Run fscrypt on an encrypted directory
+#
+
+. ./common/preamble
+_begin_fstest auto quick encrypt
+echo
+
+# Import common functions.
+. ./common/filter
+. ./common/encrypt
+
+# real QA test starts here
+_supported_fs generic
+_require_scratch_encryption -v 2
+
+_scratch_mkfs_encrypted &>> $seqres.full
+_scratch_mount
+
+dir=$SCRATCH_MNT/dir
+mkdir $dir
+
+_set_encpolicy $dir $TEST_KEY_IDENTIFIER
+_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY"
+
+args=$(_scale_fsstress_args -p 4 -n 10000 -p 2 $FSSTRESS_AVOID -d $dir)
+echo "Run fsstress $args" >>$seqres.full
+
+$FSSTRESS_PROG $args >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/736.out b/tests/generic/736.out
new file mode 100644
index 00000000..022754df
--- /dev/null
+++ b/tests/generic/736.out
@@ -0,0 +1,3 @@
+QA output created by 736
+
+Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
-- 
2.41.0

