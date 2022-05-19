Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4822552C9FC
	for <lists+linux-fscrypt@lfdr.de>; Thu, 19 May 2022 05:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbiESDGK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 18 May 2022 23:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233049AbiESDGJ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 18 May 2022 23:06:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1456B3CFEE;
        Wed, 18 May 2022 20:06:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF0616190E;
        Thu, 19 May 2022 03:06:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E6BC385A5;
        Thu, 19 May 2022 03:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652929566;
        bh=9qOFUq/lpbubY4Pgg4LomrYbZgcFce8ILsuHL2uzdII=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ixqcTcwA1w3QGsa/sk11i4rBPAlGlqHe6ktmLVbib0LWYumcp2whX96lrLfL5VC9l
         /JoBjtxhevuXQTq7cUmAhF/9OY8FqQCPx0SRakFwpX337p7nfNkZrx/Wbf6OOwqK42
         Smo1YLswuM7fFz6XG4kC9tgtnz6j3qWxB/6kzlfJ/NnXus2z2MOlUrjavxBl8jqbn1
         9lS4H9pWMgx5shhdQfpesaOH6oWrqm6pr9fPrF8o9wVc0cer2M+ti6WCxZB7Zm0nD7
         HSpPrHSuT72w91qt/6E4id0VE+ADR7xA+AbdGW8hyxsfoEoiMGjXOIqxZcq8D5PLuQ
         E5Gz5BXOUpfpA==
Date:   Wed, 18 May 2022 20:06:04 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Zhang Jianhua <chris.zjh@huawei.com>
Cc:     tytso@mit.edu, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next v2] fs-verity: Use struct_size() helper in
 enable_verity()
Message-ID: <YoW0HG+Nbg681yWL@sol.localdomain>
References: <20220519022450.2434483-1-chris.zjh@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519022450.2434483-1-chris.zjh@huawei.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, May 19, 2022 at 10:24:50AM +0800, Zhang Jianhua wrote:
> Also, address the following sparse warning:
> fs/verity/enable.c:205:28: warning: using sizeof on a flexible structure

How can I reproduce this warning?  I am using the latest version of sparse, and
I don't see any of these warnings you're reporting.

$ sparse --version
v0.6.4
$ make C=2 fs/verity/
  CHECK   scripts/mod/empty.c
  CALL    scripts/checksyscalls.sh
  CALL    scripts/atomic/check-atomics.sh
  DESCEND objtool
  CHECK   fs/verity/enable.c
  CHECK   fs/verity/hash_algs.c
  CHECK   fs/verity/init.c
  CHECK   fs/verity/measure.c
  CHECK   fs/verity/open.c
  CHECK   fs/verity/read_metadata.c
  CHECK   fs/verity/verify.c
  CHECK   fs/verity/signature.c

- Eric
