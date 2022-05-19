Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9811552C99A
	for <lists+linux-fscrypt@lfdr.de>; Thu, 19 May 2022 04:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232696AbiESCJB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 18 May 2022 22:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232713AbiESCI7 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 18 May 2022 22:08:59 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52DB13DA47;
        Wed, 18 May 2022 19:08:58 -0700 (PDT)
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 24J28j3s020022
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 22:08:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1652926127; bh=Sodfua2E8TPyApI5W9tYm1RDjEIUwIZUK14S5DsMn14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=FN2ddy5+IwQv/r0PUkk8qR11tXDhwX6U30RHCXYJ/quVFOM3DfGSdQ1Tjgrcm2unI
         /aoiGIr7ZkUYQmnQ7w9OuoVel7p59m9NMdb/QFOu59gNTgKyZLi0iGgXUqTPoisHbI
         PNv2y7UfodpRq5r51Pf2rSQVr66CXbwlLkZVS5pC4PX0P56DLP1XL1QpZaIoqCjjpt
         QIEjZX/AIkLVYN3LM7PxXB8xJ4Zx2A7rhIMM2Bgv6XgGLRSpS7TkTfQ2F5r5nzLalm
         2mWqxbdKW4a9lZ1VJNQ6+k6tUFZ5ea8hlk1MhsmXfazzub4ZpbsUbiNtivdxbshfMO
         G3VTXJRjbZMOA==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 6D9C515C3EC0; Wed, 18 May 2022 22:08:45 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Ritesh Harjani <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org
Cc:     "Theodore Ts'o" <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCHv3 0/3] ext4/crypto: Move out crypto related ops to crypto.c
Date:   Wed, 18 May 2022 22:08:44 -0400
Message-Id: <165292603479.1202345.2325254908745666453.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <cover.1652595565.git.ritesh.list@gmail.com>
References: <cover.1652595565.git.ritesh.list@gmail.com>
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

On Sun, 15 May 2022 12:07:45 +0530, Ritesh Harjani wrote:
> Please find the v3 of this cleanup series. Thanks to Eric for his quick
> review of the patch series.
> 
> Description
> =============
> This is 1st in the series to cleanup ext4/super.c, since it has grown quite
> large. This moves out crypto related ops and few fs encryption related
> definitions to fs/ext4/crypto.c
> 
> [...]

Applied, thanks!

[1/3] ext4: Move ext4 crypto code to its own file crypto.c
      commit: ebe541bdc293d4b2511bc4abb640dcddd454e54c
[2/3] ext4: Cleanup function defs from ext4.h into crypto.c
      commit: df56bae5a36f891021ea868657ab85f501d85176
[3/3] ext4: Refactor and move ext4_ioctl_get_encryption_pwsalt()
      commit: a137c5b48cb48b6c2885eeeec398433a435cf078

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
