Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9494C776F47
	for <lists+linux-fscrypt@lfdr.de>; Thu, 10 Aug 2023 06:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbjHJEzZ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 10 Aug 2023 00:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjHJEzX (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 10 Aug 2023 00:55:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985D52115;
        Wed,  9 Aug 2023 21:55:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3846863FC9;
        Thu, 10 Aug 2023 04:55:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C568C433C8;
        Thu, 10 Aug 2023 04:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691643322;
        bh=Vx2owTG4NGz+TwNKdwXeytUvxkYln70M0w0M15r7KPY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=am+Gv6pZ27t0iMcQf/hH+7uTBAE0Rn6q9rVtsmKBJg+TsD8fgtQUhJfN3cGeCrtOQ
         +RCFm7tjqSX52lzEydiMLa9d6NxptLRjl6FNZDHTF9aDhVcXWsSCDMG6eRZFQ6yzH8
         ch5QlkW6Vg4JqJdVZ6z/CYMMMYtnSf5hz3K7ahoh9LM+7WvlhjHwUObxLGeWji+TnX
         5pml2WinPzFR0I+hWwOTE5Dm8acyC57XHRng9WiRU+bR/Ttw4TuRY0t7YDLtCxoDNm
         B4g3Pvy1iVEJRRCTXhpIEGyPHdBo4m5LRHca3EH/UhEeaU18KCqaLSKOaA0Ukex6O1
         Gkvb09mfKNPww==
Date:   Wed, 9 Aug 2023 21:55:20 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v3 00/16] fscrypt: add extent encryption
Message-ID: <20230810045520.GA923@sol.localdomain>
References: <cover.1691505882.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1691505882.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Aug 08, 2023 at 01:08:17PM -0400, Sweet Tea Dorminy wrote:
> This applies atop [3], which itself is based on kdave/misc-next. It
> passes encryption fstests with suitable changes to btrfs-progs.

Where can I find kdave/misc-next?  The only mention of "kdave" in MAINTAINERS is
the following under BTRFS FILE SYSTEM:

T:      git git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git

But that repo doesn't contain a misc-next branch.

- Eric
