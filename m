Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA0B6DCB79
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Apr 2023 21:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjDJTTc (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Apr 2023 15:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbjDJTTb (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Apr 2023 15:19:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF26D1994
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Apr 2023 12:19:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79BC7614D8
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Apr 2023 19:19:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD458C4339B;
        Mon, 10 Apr 2023 19:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681154369;
        bh=pFRb+fndOJRJj/BYpNlOlCDMFzjimvJ/ZB0LLJYTSbc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QRBUvc5uExMVr3zFtVXnAMjlVQA6wBzp2mrGUBUrj+3IOznfZ6pEVwjb95W35CMAl
         S2rZdnTiCVaxKvw9IDphq2cM+fwI2U47HuFTdTmv6QdNjjjy6ipoWsaw+BqsrsV+Be
         KAbm/6ana/+0rZS8V7XjUrIf+bI0sDXjVrp8YarguQwg073Kf67B9QwrE0L/U1jsBg
         BSbtp0nM4Upo867l2x9jniCNIEnVlc8RBFIT6+F8qsmUosR5CMM5SedBa/CDEsX7mT
         uxX6XbqvdqY0ydqlmsWRvjirFS6IgEHf05jjGJVierYPu1wNQ9nool5wZ1jMm+e8xu
         Isr3iBE+3HsYw==
Date:   Mon, 10 Apr 2023 19:19:28 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     tytso@mit.edu, jaegeuk@kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@meta.com
Subject: Re: [PATCH v1 00/10] fscrypt: rearrangements preliminary to extent
 encryption
Message-ID: <ZDRhQGYfOsJjzbjx@gmail.com>
References: <cover.1681116739.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1681116739.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Apr 10, 2023 at 06:16:21AM -0400, Sweet Tea Dorminy wrote:
> Patchset should apply cleanly to fscrypt/for-next

It doesn't apply.  What is the base commit?

- Eric
