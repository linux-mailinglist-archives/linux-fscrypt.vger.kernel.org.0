Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5DA0516202
	for <lists+linux-fscrypt@lfdr.de>; Sun,  1 May 2022 07:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241060AbiEAFYv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 May 2022 01:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241046AbiEAFYu (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 May 2022 01:24:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F37413D4B;
        Sat, 30 Apr 2022 22:21:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF43561188;
        Sun,  1 May 2022 05:21:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9FBC385AA;
        Sun,  1 May 2022 05:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651382486;
        bh=oqw2QlJKv5HbaXvjkUeK2eClFe54dcF0yYz3t+B3oWU=;
        h=From:To:Cc:Subject:Date:From;
        b=dN6n4uIyFWqGhNfR1YrNSS0JK0RGp/5leaeNN/hvXLWxyKFMfV5sPCoM89fDDIRLB
         5g91Zdl77hNXZuQYVOGGB45LtF9SAlJSj3jVqg8+z+3GTM4c+XoYjU4L22dS2WyhuT
         1sojW1EPW0KbLNRXs+/BILLxPn1ETwrGahFULyIAABPGF+Sum7hGRp0h0WLzuR7Uv1
         LObSuo0jRI51L7S7V6f594gyyXpxaMvUpb6lr2WjFTeAYUXUrIcE7zy7dBEBnhnoig
         P6pLmzHe7g0NOPFMzWNG0K9ilS6Z3NP+XoEK5lHQBYPpjFdFY6L7P3fhF0FJvjLMqZ
         BTUV8RdrsTtkg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        Lukas Czerner <lczerner@redhat.com>
Subject: [xfstests PATCH 0/2] update test_dummy_encryption testing in ext4/053
Date:   Sat, 30 Apr 2022 22:19:26 -0700
Message-Id: <20220501051928.540278-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This series updates the testing of the test_dummy_encryption mount
option in ext4/053.

The first patch will be needed for the test to pass if the kernel patch
"ext4: only allow test_dummy_encryption when supported"
(https://lore.kernel.org/r/20220501050857.538984-2-ebiggers@kernel.org)
is applied.

The second patch starts testing a case that previously wasn't tested.
It reproduces a bug that was introduced in the v5.17 kernel and will
be fixed by the kernel patch
"ext4: fix up test_dummy_encryption handling for new mount API"
(https://lore.kernel.org/r/20220501050857.538984-6-ebiggers@kernel.org).

This applies on top of my recent patch
"ext4/053: fix the rejected mount option testing"
(https://lore.kernel.org/r/20220430192130.131842-1-ebiggers@kernel.org).

Eric Biggers (2):
  ext4/053: update the test_dummy_encryption tests
  ext4/053: test changing test_dummy_encryption on remount

 tests/ext4/053 | 38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

-- 
2.36.0

