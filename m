Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4076C0479
	for <lists+linux-fscrypt@lfdr.de>; Sun, 19 Mar 2023 20:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjCSTjh (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 19 Mar 2023 15:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbjCSTja (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 19 Mar 2023 15:39:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC2D12CE3;
        Sun, 19 Mar 2023 12:39:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C71CFB80C76;
        Sun, 19 Mar 2023 19:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2B7C433D2;
        Sun, 19 Mar 2023 19:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679254743;
        bh=FWkHjNQ1cL40j5SackGi2ME0bHDKXNYoN1O5VYU9u78=;
        h=From:To:Cc:Subject:Date:From;
        b=b01MGHU5HnquASvJUxCqQ0vQT7m1M7ZeM4766iksSJtfAqCF3QhkXPleU/N/yTg2G
         fJ81y/d/ET8GLq41hYLTk6vuXZ1K1FGhyvl5XNI0WhuNNE2xdW1FJ0M1keuf1uN9P2
         yBTo3CYWn2MKXCu//cTG+mGP995HKLx2bWhWafQXqqkreeQd4gThvA0Av9xVsMwNGz
         sxcm95djiLlMiyi7E719zxymsxuaOMbjXuHxS7huUWMXHV5yRIAKLlh5PHRJlg4Ldi
         BBmBWl9+8s5wNIqhHxYREGzmIVMCqiGtY+BKQ3+8F30gzsxL+fIR3YTrSlF+Yvk31c
         f8BXwITuPXlWw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 0/3] xfstests: make fscrypt-crypt-util self-tests work with OpenSSL 3.0
Date:   Sun, 19 Mar 2023 12:38:44 -0700
Message-Id: <20230319193847.106872-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This series makes the algorithm self-tests in fscrypt-crypt-util (which
are not compiled by default) work with OpenSSL 3.0.  Previously they
only worked with OpenSSL 1.1.

Eric Biggers (3):
  fscrypt-crypt-util: fix HKDF self-test with latest OpenSSL
  fscrypt-crypt-util: use OpenSSL EVP API for AES self-tests
  fscrypt-crypt-util: fix XTS self-test with latest OpenSSL

 src/fscrypt-crypt-util.c | 46 ++++++++++++++++++++++++++++++++--------
 1 file changed, 37 insertions(+), 9 deletions(-)

-- 
2.40.0

