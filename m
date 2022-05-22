Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 235A653004A
	for <lists+linux-fscrypt@lfdr.de>; Sun, 22 May 2022 04:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbiEVCcF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 21 May 2022 22:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiEVCcF (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 21 May 2022 22:32:05 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E745A34647;
        Sat, 21 May 2022 19:32:02 -0700 (PDT)
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 24M2VmPC006110
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 21 May 2022 22:31:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1653186710; bh=IzQhsbhHWeNT5Ib9P4izdH+zZDT7w5Gp6o7vfD6cqEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=PHsazClU2hpGX3E/Jqyg4YIKR3tKIuWheXKFB2zMUyCNojVe6TaGuh30JWM/79gC5
         1dfAW06QBPBcjcAXNsMaFwe7q0sSkpuJrML6VkAqzTgIbU6n7jtQYHS4L+Eb9NFRjC
         6mkTaDEOqTyMNuRS1x/j1i9mWYvmQkpUJWwDmVwGSmel6gm6NkYvDIXIcBlmTBqmhn
         tZgMq2u+yvm38mivsNTKVS2Xu6S9n/IoyNftK9BpcuTnZqfFkANLJgIVa0xrGH8BV7
         EJ4AVdcjLmUbLXtTh9z0Sx7sD1WVTcubLULsPP1QGa2oGVqOtDE4bi+PxgJ9Oz/dRZ
         CXHMCovyuY32g==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 9030715C3EC0; Sat, 21 May 2022 22:31:48 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     linux-ext4@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v4] ext4: only allow test_dummy_encryption when supported
Date:   Sat, 21 May 2022 22:31:47 -0400
Message-Id: <165318668323.1718738.16352700096125589456.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220519204437.61645-1-ebiggers@kernel.org>
References: <20220519204437.61645-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, 19 May 2022 13:44:37 -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Make the test_dummy_encryption mount option require that the encrypt
> feature flag be already enabled on the filesystem, rather than
> automatically enabling it.  Practically, this means that "-O encrypt"
> will need to be included in MKFS_OPTIONS when running xfstests with the
> test_dummy_encryption mount option.  (ext4/053 also needs an update.)
> 
> [...]

I've replaced the older version of the commit with this one, thanks!

[1/1] ext4: only allow test_dummy_encryption when supported
      commit: d177c151d74881536aa6b58f450c70fd5a7b6c1a

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
