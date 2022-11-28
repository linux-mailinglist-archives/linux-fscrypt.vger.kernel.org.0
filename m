Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8880D63B1D0
	for <lists+linux-fscrypt@lfdr.de>; Mon, 28 Nov 2022 20:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbiK1TDW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 28 Nov 2022 14:03:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232822AbiK1TDU (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 28 Nov 2022 14:03:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89AF727FFA;
        Mon, 28 Nov 2022 11:03:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BA0361372;
        Mon, 28 Nov 2022 19:03:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF32C433D6;
        Mon, 28 Nov 2022 19:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669662198;
        bh=F0+RGrIEwEfbme6pt/5jbjGiLsDseYFGTIlLzhQ4Kl4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZrJ+ewUetTn9qDOZgHo6rtlemBLq8hcCFOa3JVIgTfARoPoNvGnLHKX0fRFsZrsN4
         x7RQwJ1P/YHf0AlSglEf+vlOBR/cwDWcE1X2gbzKwU/dLlaBJIbL8036vtoQPVphOd
         rGYyA4Uo3THAcyPN7isIkSvw9rqDUXRDR45hcb7yt6Yfoyf4Qs5WUd80TtZR9WoDkw
         +3ra3n/Yu0A5jimpTHH2fCpmi4J3XlVp5NtTypmrRYdAMStDP/DNuDDFOMwoSnm3BD
         /2u0LuF+qVoaZxJ6BSnIiNcWlui8wD9DIb28xxzN+k5ea5UJReTOqgi1Ou6Gd5XNAz
         yh29Y8Acd84vQ==
Date:   Mon, 28 Nov 2022 19:03:17 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Subject: Re: [PATCH 0/7] ext4 fast-commit fixes
Message-ID: <Y4UF9VntxPnoA+SW@gmail.com>
References: <20221106224841.279231-1-ebiggers@kernel.org>
 <Y3Q6U3jd3dI33xdJ@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3Q6U3jd3dI33xdJ@sol.localdomain>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Nov 15, 2022 at 05:18:11PM -0800, Eric Biggers wrote:
> On Sun, Nov 06, 2022 at 02:48:34PM -0800, Eric Biggers wrote:
> > 
> > This series fixes several bugs in the fast-commit feature.
> > 
> > Patch 6 may be the most controversial patch of this series, since it
> > would make old kernels unable to replay fast-commit journals created by
> > new kernels.  I'd appreciate any thoughts on whether that's okay.  I can
> > drop that patch if needed.
> > 
> > I've tested that this series doesn't introduce any regressions with
> > 'gce-xfstests -c ext4/fast_commit -g auto'.  Note that ext4/039,
> > ext4/053, and generic/475 fail both before and after.
> > 
> > Eric Biggers (7):
> >   ext4: disable fast-commit of encrypted dir operations
> >   ext4: don't set up encryption key during jbd2 transaction
> >   ext4: fix leaking uninitialized memory in fast-commit journal
> >   ext4: add missing validation of fast-commit record lengths
> >   ext4: fix unaligned memory access in ext4_fc_reserve_space()
> >   ext4: fix off-by-one errors in fast-commit block filling
> >   ext4: simplify fast-commit CRC calculation
> > 
> >  fs/ext4/ext4.h              |   4 +-
> >  fs/ext4/fast_commit.c       | 203 ++++++++++++++++++------------------
> >  fs/ext4/fast_commit.h       |   3 +-
> >  fs/ext4/namei.c             |  44 ++++----
> >  include/trace/events/ext4.h |   7 +-
> >  5 files changed, 132 insertions(+), 129 deletions(-)
> > 
> > 
> > base-commit: 089d1c31224e6b266ece3ee555a3ea2c9acbe5c2
> 
> Any thoughts on this patch series?
> 
> - Eric

Ping?

- Eric
