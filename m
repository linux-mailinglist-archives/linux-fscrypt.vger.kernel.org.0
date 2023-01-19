Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAC52673D77
	for <lists+linux-fscrypt@lfdr.de>; Thu, 19 Jan 2023 16:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjASP1T (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 19 Jan 2023 10:27:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbjASP1T (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 19 Jan 2023 10:27:19 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7480B8088B
        for <linux-fscrypt@vger.kernel.org>; Thu, 19 Jan 2023 07:27:18 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 30JFRAnA011438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 10:27:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1674142031; bh=1WSfz+N28EDsaUKko2XguqnvWug/hHIXM/zOxbYoRsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=i3P6FIB/Luj61gPoqgW/uvpMyXauut28JuUUv107/eFaX7hvrqOy6MxsXn6PqQHhU
         6IfHbBeqRoZwV2p8BrvPF52iByqP6JK+7vjjEXGT+nPBEF1x5NEk+LP+ohcmvWA41E
         uvc0fQAdVeo6KLdBXhO5FxjRZE52gc5De2l7rPUzhu+iONDi51SoJt2MKYpY3WMIDg
         rTGYwYlvy6RsDG12mT/HZD7XwtZKGZ1AbIxhcqDxmKzcwxZMeAnjWBE5xWNQzsX51f
         4k0CYkCf9kX9PYcNifCh2QlSE5rRxSrB7pa/vj2hDCYUg1ZiTWP9oHHAkuNmvSUBvp
         vBBzKd85wNfIA==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 079A015C469B; Thu, 19 Jan 2023 10:27:10 -0500 (EST)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>, linux-ext4@vger.kernel.org
Cc:     "Theodore Ts'o" <tytso@mit.edu>, linux-fscrypt@vger.kernel.org
Subject: Re: [e2fsprogs PATCH v2] e2fsck: don't allow journal inode to have encrypt flag
Date:   Thu, 19 Jan 2023 10:27:05 -0500
Message-Id: <167414201626.2737146.9945075617467030108.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20221102220551.3940-1-ebiggers@kernel.org>
References: <20221102220551.3940-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, 2 Nov 2022 15:05:51 -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Since the kernel is being fixed to consider journal inodes with the
> 'encrypt' flag set to be invalid, also update e2fsck accordingly.
> 
> 

Applied, thanks!

[1/1] e2fsck: don't allow journal inode to have encrypt flag
      commit: b0cd09e5b65373fc9f89048958c093bb1e6a1ecb

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
