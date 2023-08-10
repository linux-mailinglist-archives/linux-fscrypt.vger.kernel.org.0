Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54E73777EF1
	for <lists+linux-fscrypt@lfdr.de>; Thu, 10 Aug 2023 19:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234600AbjHJRRG (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 10 Aug 2023 13:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231994AbjHJRRF (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 10 Aug 2023 13:17:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99B226B6;
        Thu, 10 Aug 2023 10:17:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FA966569A;
        Thu, 10 Aug 2023 17:17:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4AEC433C8;
        Thu, 10 Aug 2023 17:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691687823;
        bh=h99BwNaU2GECabGZGnRamGFDk8eaIdWVZOne7S+dVmU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vNeP4Sr3adt6TLMeqes1Z8uO5PrmXjdTFTqiBGEi2gQp/iPKb+xsq++rRS+BFU+jU
         B/G3Gv2ttzXzZYP8f/4z6vdmP1T2XPi3ti5ROzWIIvYYxNGtwYEzLRcue/XTWeKpAG
         7olT8PQ2OA4ZeN6IrO7VBKss1SqK2KTux45qWU876z1Pq9a9w9wt01jiuXKXVcbrnD
         Wq0qjQHzW0uaf0+xO9IazNJrfWiZUBthswR2528ZdPn4mGTvuz5GLf1maZqxKF7LQE
         6tHhh9rs7nIUOUASi8/EhbnZzLo7Ouy0gQwx/ZgJHdtcH3DFk26u1XQks7S7WQ3kep
         LQbrvZ8CKAKJw==
Date:   Thu, 10 Aug 2023 17:17:02 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v3 00/16] fscrypt: add extent encryption
Message-ID: <20230810171702.GB701926@google.com>
References: <cover.1691505882.git.sweettea-kernel@dorminy.me>
 <20230810045520.GA923@sol.localdomain>
 <408f6654-4fc7-7ae5-616d-6b5ecc24eb2a@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <408f6654-4fc7-7ae5-616d-6b5ecc24eb2a@dorminy.me>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Aug 10, 2023 at 10:11:56AM -0400, Sweet Tea Dorminy wrote:
> 
> 
> On 8/10/23 00:55, Eric Biggers wrote:
> > On Tue, Aug 08, 2023 at 01:08:17PM -0400, Sweet Tea Dorminy wrote:
> > > This applies atop [3], which itself is based on kdave/misc-next. It
> > > passes encryption fstests with suitable changes to btrfs-progs.
> > 
> > Where can I find kdave/misc-next?  The only mention of "kdave" in MAINTAINERS is
> > the following under BTRFS FILE SYSTEM:
> > 
> > T:      git git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
> > 
> > But that repo doesn't contain a misc-next branch.
> > 
> > - Eric
> 
> I should've mentioned that more explicitly since the btrfs dev tree isn't
> listed in MAINTAINERS. https://github.com/kdave/btrfs-devel/tree/misc-next
> 

Does this mean that MAINTAINERS needs to be updated?

- Eric
