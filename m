Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70CAE59900E
	for <lists+linux-fscrypt@lfdr.de>; Fri, 19 Aug 2022 00:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235059AbiHRWGR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 18 Aug 2022 18:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232990AbiHRWGQ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 18 Aug 2022 18:06:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206A3D21F7;
        Thu, 18 Aug 2022 15:06:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9314E616DD;
        Thu, 18 Aug 2022 22:06:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC524C433D6;
        Thu, 18 Aug 2022 22:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660860374;
        bh=NWLYGfQR0Pu+gzibBkG/wtn6mdfINHCh22TTdiNbfmw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gr04WdDSyI6tEbIgTSI0STnjQERw28rs/0TXcK/b8WpfH1kCaTjQCByflKN7171VF
         poKhIDX3BpVW/A9kBK4Sn9mAKovjAKqUb2xKgRbNInfe96mnYEB91qClWG28F2wURO
         n/VkqXUIgxKKnTdH1lQV4ZAElFXERsH58YV/uKNTGTnKofsiBNgTI86atg+JV65igd
         7pKxjMUnBag+xHIABvMH7ew/V6ZpmuOd7jo/EF1IDJ0DIVKiit4OB44Ipjo5UHK4h4
         O6o9bW1cEBFttywftLe/6D9Joa+rhX8uVXFdCdlVY4u9SSWqtNqjbNgnmoU0UePIeo
         KzqJVrhdL6Nlw==
Date:   Thu, 18 Aug 2022 15:06:12 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH v2] fstests: add btrfs fs-verity send/recv test
Message-ID: <Yv631GfQnz1n0Xhd@sol.localdomain>
References: <e2a327a5ac21cfd532b0ae5c936171dc178308ec.1660851850.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2a327a5ac21cfd532b0ae5c936171dc178308ec.1660851850.git.boris@bur.io>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Aug 18, 2022 at 12:47:59PM -0700, Boris Burkov wrote:
> Test btrfs send/recv support for fs-verity. Includes tests for
> signatures, salts, and interaction with chmod/caps. The last of those is
> to ensure the various features that go in during inode_finalize interact
> properly.
> 
> This depends on the kernel patch adding support for send:
> btrfs: send: add support for fs-verity
> 
> And the btrfs-progs patch adding support for recv:
> btrfs-progs: receive: add support for fs-verity
> 
> Signed-off-by: Boris Burkov <boris@bur.io>
> --
> Changes for v2:

The changelog should be below the real scissors line "---" so that it's not
included in the commit message.

> - change 0/1 to false/true

This wasn't actually done.

Otherwise this test looks fine.

- Eric
