Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF934D720A
	for <lists+linux-fscrypt@lfdr.de>; Sun, 13 Mar 2022 02:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbiCMBHp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 12 Mar 2022 20:07:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232296AbiCMBHo (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 12 Mar 2022 20:07:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C51148673;
        Sat, 12 Mar 2022 17:06:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C69BB80123;
        Sun, 13 Mar 2022 01:06:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E841C340EB;
        Sun, 13 Mar 2022 01:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647133595;
        bh=gKCPK1CZydLFQnN48XiydmgDLWHBROPmToWgQcg1y3I=;
        h=From:To:Cc:Subject:Date:From;
        b=l2VsyGe/k2pBXtfaSrDXoAqIojxm+dxChc2K0Zwmq26YnfCGa3osCuxJiqQIwSluq
         fkZtvUnFz+y6EJ5nRC/8/WIFvsYpEvTAbIY54hI4hN3Vq68M444ut9rFxfopZl6C98
         LdBrbRxuRjEhDRJZw/ye2ax0lOlHyGGhVOM1115+RcvqDcnrzQQHGKT/LPG5IViXQ2
         Ntdsp10HmzXYF6xGnErk2lVwx3gBUcWfb1LKxOUjA9VgvEbQQFfBVsowokz7rx879P
         LJg1YcGxh9Gipfv8BHhGmHUsOAO1XGfjDcedDLFA7SCndrCOlVrwzOD0kot9YDAy5A
         R4ABbnXMMDc3A==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH v2 0/5] xfstests: fscrypt test cleanups
Date:   Sat, 12 Mar 2022 17:05:54 -0800
Message-Id: <20220313010559.545995-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This series makes some minor improvements to the fscrypt ciphertext
verification tests.  I've split these out from my series
"[RFC PATCH 0/8] xfstests: test the fscrypt hardware-wrapped key support"
(https://lore.kernel.org/fstests/20220228074722.77008-1-ebiggers@kernel.org/T/#u)
and updated them slightly.  These can be applied now.

I've verified that all the 'encrypt' group tests still pass with this
series applied.

Eric Biggers (5):
  fscrypt-crypt-util: use an explicit --direct-key option
  fscrypt-crypt-util: refactor get_key_and_iv()
  fscrypt-crypt-util: add support for dumping key identifier
  common/encrypt: log full ciphertext verification params
  common/encrypt: verify the key identifiers

 common/encrypt           |  34 +++++--
 src/fscrypt-crypt-util.c | 193 ++++++++++++++++++++++++++-------------
 2 files changed, 159 insertions(+), 68 deletions(-)

-- 
2.35.1

