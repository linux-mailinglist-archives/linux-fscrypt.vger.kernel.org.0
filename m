Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F20F61A2D5
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Nov 2022 21:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiKDU7V (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 4 Nov 2022 16:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiKDU7U (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 4 Nov 2022 16:59:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACBEE3F05F;
        Fri,  4 Nov 2022 13:59:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 25663CE2E3B;
        Fri,  4 Nov 2022 20:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A8DC433C1;
        Fri,  4 Nov 2022 20:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667595553;
        bh=2DnjCwJhhqMLCsZwA0rRCeG/AkUzh69QXfmEHZY+dz4=;
        h=From:To:Cc:Subject:Date:From;
        b=s4vWe4rqi2o//OUfOcniAfs3S/x0IFNiVZfbLlQBCRYHeHPkckFKcqYbgGv9P2LbQ
         VlwGPs1jz+tc1NsWWnUumXAXeqf+8HLNBuj2C18T+GVrARcIYNY4+tGGb8u7bEod6x
         6WDt7JgDqjDqUvUegf6QxE1kieXVob+M6AB/Q6CdON2lPA4iXsDcmqVZ05Mr9AFDaW
         Mo9eoSrq/ro106rFUfhvgS4pjzjlwb0VmLCPIWxGIcg5/75FEEd9ZoINOhLx0Zee1Y
         IubOeAp0vj5Lz4F39ls4vQxXPT8AkVnnN3EA4LMtITiTb9acgw33O2cn77nMQnD5D2
         VQ0hxx99vvO4w==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org,
        Andrey Albershteyn <aalbersh@redhat.com>
Subject: [xfstests PATCH v2 0/3] Fix test bugs related to fs.verity.require_signatures
Date:   Fri,  4 Nov 2022 13:58:27 -0700
Message-Id: <20221104205830.130132-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This is a replacement for Andrey's patchset
"generic/577: fix hash check and add metadata cleaning".
It handles some other things that were overlooked.

Changed v1 => v2:
   - Slight code simplification (kept check for require_signatures
     existence in _disable_fsverity_signatures() only)
   - Added Reviewed-by tags

Eric Biggers (3):
  common/verity: fix _fsv_have_hash_algorithm() with required signatures
  generic/577: add missing file removal before empty file test
  tests: fix some tests for systems with fs.verity.require_signatures=1

 common/verity     | 58 ++++++++++++++++++++++++++++++-----------------
 tests/btrfs/290   |  9 ++++++++
 tests/btrfs/291   |  2 ++
 tests/generic/577 |  1 +
 tests/generic/624 |  8 +++++++
 tests/generic/692 |  8 +++++++
 6 files changed, 65 insertions(+), 21 deletions(-)


base-commit: a75c5f50584e03ca7862ad51f48efd2d524d1dc5
-- 
2.38.1

