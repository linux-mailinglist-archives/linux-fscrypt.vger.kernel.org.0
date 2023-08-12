Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C94B877A3D0
	for <lists+linux-fscrypt@lfdr.de>; Sun, 13 Aug 2023 00:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjHLWnC (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 12 Aug 2023 18:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjHLWnB (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 12 Aug 2023 18:43:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C9793;
        Sat, 12 Aug 2023 15:43:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3827461769;
        Sat, 12 Aug 2023 22:43:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551AFC433C8;
        Sat, 12 Aug 2023 22:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691880183;
        bh=CbC9JInFmjulwcz4C33K7BEDvX9wo/dSMwUbqt+ZdH4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BtRkTRqOFnjCQGBKXtBFZw7PMH+yAlhkYNShFgpKCrTPsVMA/U43qtNHdf/3lvx33
         FJkocPTDz73i3mw73rZKGNdWd3gfRG0ePadF6hZg32Yt4NKhCCXbectkds77H1+OJr
         AePzwgb22zTDMzUyW9KN4J8OgIDenIhdMMVR4ja5oWKVL1kA76ud+TmoHdgNnnHYkw
         ewZeIbOoyTCEgcK60FyPQQtL/wFrVNp0xke6aLrsraug2JDjGndj5BQjUoOaMmSTEM
         Lu5cwDlDkjnwvXRDXDgwvlCE6X4PEUGJyKRun0onJEmVnVbSgsjbHyuv1gb2gp+UZI
         qUDkji1u+v3ag==
Date:   Sat, 12 Aug 2023 15:43:01 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v3 15/16] fscrypt: allow asynchronous info freeing
Message-ID: <20230812224301.GC41642@sol.localdomain>
References: <cover.1691505882.git.sweettea-kernel@dorminy.me>
 <6c4a29fdfabf90f1a43dffff04debd54f941cf93.1691505882.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c4a29fdfabf90f1a43dffff04debd54f941cf93.1691505882.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Aug 08, 2023 at 01:08:32PM -0400, Sweet Tea Dorminy wrote:
> btrfs sometimes frees extents while holding a mutex. This makes it hard
> to free the prepared keys associated therewith, as the free process may
> need to take a semaphore. Just offloading freeing to rcu doesn't work,
> as rcu may call the callback in softirq context, which also doesn't
> allow taking a semaphore. Thus, for extent infos, offload their freeing
> to the general system workqueue.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

Please be specific about which mutex and which semaphore.

What is the specific problem?

- Eric
