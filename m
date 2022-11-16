Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE7162B073
	for <lists+linux-fscrypt@lfdr.de>; Wed, 16 Nov 2022 02:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbiKPBSR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 15 Nov 2022 20:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbiKPBSQ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 15 Nov 2022 20:18:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7EF627FFC;
        Tue, 15 Nov 2022 17:18:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A76BB818C7;
        Wed, 16 Nov 2022 01:18:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9600C433D6;
        Wed, 16 Nov 2022 01:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668561493;
        bh=lEEWxdoK1QtS47A/ucctKYK1Vv179vUD7DzjOdQutys=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XkfIfbNuEpd9HQ/DRFyO+44JfMF+3SDuVit1IxUnvA+2Dgw224a8Ou1Kk6/Vb0yM5
         zNuVbzPZjrabyxq8czmCYSWFIXHwhY7vgzHR71zeP3JtP4VtIgvCuUYBT4YNtmPs79
         zh+raALO95KD+1wZS4rboRVfk5x0qFwjSrrFwEdcxpgd4Nv8wt+ZgR1pArI6Ku6edT
         FLT5UQAmLerHFEnLnGkK+CTaF/1BtK5pYfPmvWNhtLE29IXh7gDHAOwpVQxIeQLPfq
         k9ccJa9LI8LdHRnEGxc3lFhhGPY+UXwOwnpTA2bqsyDqO2QD5HiPpXKvnGLSILMDJx
         RojTK2VYY59Qg==
Date:   Tue, 15 Nov 2022 17:18:11 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Subject: Re: [PATCH 0/7] ext4 fast-commit fixes
Message-ID: <Y3Q6U3jd3dI33xdJ@sol.localdomain>
References: <20221106224841.279231-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221106224841.279231-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Nov 06, 2022 at 02:48:34PM -0800, Eric Biggers wrote:
> 
> This series fixes several bugs in the fast-commit feature.
> 
> Patch 6 may be the most controversial patch of this series, since it
> would make old kernels unable to replay fast-commit journals created by
> new kernels.  I'd appreciate any thoughts on whether that's okay.  I can
> drop that patch if needed.
> 
> I've tested that this series doesn't introduce any regressions with
> 'gce-xfstests -c ext4/fast_commit -g auto'.  Note that ext4/039,
> ext4/053, and generic/475 fail both before and after.
> 
> Eric Biggers (7):
>   ext4: disable fast-commit of encrypted dir operations
>   ext4: don't set up encryption key during jbd2 transaction
>   ext4: fix leaking uninitialized memory in fast-commit journal
>   ext4: add missing validation of fast-commit record lengths
>   ext4: fix unaligned memory access in ext4_fc_reserve_space()
>   ext4: fix off-by-one errors in fast-commit block filling
>   ext4: simplify fast-commit CRC calculation
> 
>  fs/ext4/ext4.h              |   4 +-
>  fs/ext4/fast_commit.c       | 203 ++++++++++++++++++------------------
>  fs/ext4/fast_commit.h       |   3 +-
>  fs/ext4/namei.c             |  44 ++++----
>  include/trace/events/ext4.h |   7 +-
>  5 files changed, 132 insertions(+), 129 deletions(-)
> 
> 
> base-commit: 089d1c31224e6b266ece3ee555a3ea2c9acbe5c2

Any thoughts on this patch series?

- Eric
