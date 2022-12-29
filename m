Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02EBF659337
	for <lists+linux-fscrypt@lfdr.de>; Fri, 30 Dec 2022 00:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234253AbiL2XfK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 29 Dec 2022 18:35:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234247AbiL2XfH (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 29 Dec 2022 18:35:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9448217586;
        Thu, 29 Dec 2022 15:35:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E0F8B81A8C;
        Thu, 29 Dec 2022 23:35:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD36EC433F2;
        Thu, 29 Dec 2022 23:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672356903;
        bh=+DKfl9iH28Z2EnjFnI28ZOJlv9OShzFbDQIQpAjLgXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OqcPbArPzicCviBgJERkF9DCfXa8M0TEJc7+znb8/iJUD44TgWiIgbHMydJ+FbTwy
         KzHhy2OakPr17Tv3G3IjGn4NY2osrJUZYg2ZHU0Bn88M5MpjhRM7NsOvvIi+qxor8t
         nv1Hl5606UFQvX9lH616Tzv3odgEQk8sqyJSPy69e3x/l9vgFZa0nOeFJxbi0A7Llr
         WVAPP6sm4Kw8sq8cfs4LjrQsUyBLg8fcVpbbuWE0vzlYc83UstGX/OazdxCYbUqHeZ
         D75vAmGwo9obICur8OGYceXE/kuXxBoQPXPh70jOjG/jPV2vcjJLwW9ov7gEBr3X6X
         UGoLPv/DoP5Kw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH v3 04/10] common/verity: add _filter_fsverity_digest()
Date:   Thu, 29 Dec 2022 15:32:16 -0800
Message-Id: <20221229233222.119630-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221229233222.119630-1-ebiggers@kernel.org>
References: <20221229233222.119630-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add a filter that replaces fs-verity digests with a fixed string.  This
is needed because the fs-verity digests that some tests print are going
to start depending on the default Merkle tree block size.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/verity | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/common/verity b/common/verity
index 1c706b80..b88e839b 100644
--- a/common/verity
+++ b/common/verity
@@ -406,3 +406,11 @@ _require_fsverity_max_file_size_limit()
 		;;
 	esac
 }
+
+# Replace fs-verity digests, as formatted by the 'fsverity' tool, with <digest>.
+# This function can be used by tests where fs-verity digests depend on the
+# default Merkle tree block size (FSV_BLOCK_SIZE).
+_filter_fsverity_digest()
+{
+	sed -E 's/\b(sha(256|512)):[a-f0-9]{64,}\b/\1:<digest>/'
+}
-- 
2.39.0

