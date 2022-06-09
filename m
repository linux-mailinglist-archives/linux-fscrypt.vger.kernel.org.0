Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0077B5458D5
	for <lists+linux-fscrypt@lfdr.de>; Fri, 10 Jun 2022 01:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245471AbiFIXrD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Jun 2022 19:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbiFIXrC (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Jun 2022 19:47:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2BBFC965D;
        Thu,  9 Jun 2022 16:47:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E1616201E;
        Thu,  9 Jun 2022 23:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43018C34114;
        Thu,  9 Jun 2022 23:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654818419;
        bh=75ma3gShevB/s+RL0PO7tBwv+TZNSdvzkkGB14y8o+U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kcX+PwMw5mFGo3Hvd5s+OCw0NUn7tGUaFLmRiU7V0WspqeDtxnP4hKHuGR04d0Zh/
         CmqrhaiNPpoiltOTf+gpcxwOtF2MvuPkzFtYsPvf0fFIr2JbSi7wNC+Csv9+lRUjWi
         opbqKAFrkAoeuRc7dMMJbhCkSkK4kowoEKuE5crEYe4xnUSu/eOOgwMqFaDAPU8na3
         fphsoQ/VKiMJbP/Epu6c/rwA+3yiRDVQI2cSRN8LsM296JFCP0HRNxCApnQHSLL/bN
         I3irVFNVvS/5ZSLwPzuIsM3L6DDs8FHN/TmjloO4XV1i006u9oLMGJ4ej4H8MhUo/V
         11soWc+hYdL8Q==
Date:   Thu, 9 Jun 2022 16:46:57 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Deven Bowers <deven.desai@linux.microsoft.com>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, axboe@kernel.dk, agk@redhat.com,
        snitzer@kernel.org, eparis@redhat.com, paul@paul-moore.com,
        linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-audit@redhat.com,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v8 13/17] fsverity: consume builtin signature via LSM
 hook
Message-ID: <YqKGcdM3t5gjqBpq@sol.localdomain>
References: <1654714889-26728-1-git-send-email-deven.desai@linux.microsoft.com>
 <1654714889-26728-14-git-send-email-deven.desai@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1654714889-26728-14-git-send-email-deven.desai@linux.microsoft.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jun 08, 2022 at 12:01:25PM -0700, Deven Bowers wrote:
> From: Fan Wu <wufan@linux.microsoft.com>
> 
> fsverity represents a mechanism to support both integrity and
> authenticity protection of a file, supporting both signed and unsigned
> digests.
> 
> An LSM which controls access to a resource based on authenticity and
> integrity of said resource, can then use this data to make an informed
> decision on the authorization (provided by the LSM's policy) of said
> claim.
> 
> This effectively allows the extension of a policy enforcement layer in
> LSM for fsverity, allowing for more granular control of how a
> particular authenticity claim can be used. For example, "all (built-in)
> signed fsverity files should be allowed to execute, but only these
> hashes are allowed to be loaded as kernel modules".
> 
> This enforcement must be done in kernel space, as a userspace only
> solution would fail a simple litmus test: Download a self-contained
> malicious binary that never touches the userspace stack. This
> binary would still be able to execute.
> 
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>

The IMA support for fs-verity, which is now upstream, already does this (except
that IMA isn't an LSM).  It also doesn't rely on the fs-verity builtin
signatures, which shouldn't really be used.  Can you elaborate on how what
you're doing is better?

- Eric
