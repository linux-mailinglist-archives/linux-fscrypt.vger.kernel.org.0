Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7EC164F2DC
	for <lists+linux-fscrypt@lfdr.de>; Fri, 16 Dec 2022 22:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbiLPVCo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 16 Dec 2022 16:02:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiLPVCn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 16 Dec 2022 16:02:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D646B200;
        Fri, 16 Dec 2022 13:02:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C9E762224;
        Fri, 16 Dec 2022 21:02:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED6BC433D2;
        Fri, 16 Dec 2022 21:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671224562;
        bh=fN6m4VVYYGNJr/6EwOlSmEnRz+a52skh6EEXOuEbYAA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eVyOzd9RrBpCgJg75WD8MZcN/gi1IB8OPt6rX3Zzx/yYmmEZwjchzPb24tjMuIeni
         tlZOy5hepolDqmDwN6RI+l8mWiFqaPi+Y0qYbu3Q95I138XpgZS7NgV1Y734GmMRpJ
         6AyhmJWUsG06S8e+wtyFB8A4Ijq5pNRljDUveS6IUa8zxWE5mPZGQZnj9Exg2cco8G
         3hcmfwjE3i+1omxMkMOAIUvoht8D1qUIVtvyLeIJ0/EZMjwtfewRJm3XX9iD4e0Bfa
         3PQ+ku7tCHI5lo+ymT7FpDUKq20Tuj/nz67h0MWrqm6YecfgC0y/of5Z25PWvm5f9i
         PZPdc7K0z+qmQ==
Date:   Fri, 16 Dec 2022 13:02:39 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Fan Wu <wufan@linux.microsoft.com>
Cc:     Luca Boccassi <bluca@debian.org>, linux-fscrypt@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org, linux-integrity@vger.kernel.org,
        Jes Sorensen <jsorensen@meta.com>,
        Victor Hsieh <victorhsieh@google.com>
Subject: Re: [PATCH] fsverity: mark builtin signatures as deprecated
Message-ID: <Y5zc74DPqamqs+rH@sol.localdomain>
References: <20221208033548.122704-1-ebiggers@kernel.org>
 <eea9b4dc9314da2de39b4181a4dac59fda8b0754.camel@debian.org>
 <Y5JPRW+9dt28JpZ7@sol.localdomain>
 <20221209221719.GA3055@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209221719.GA3055@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Dec 09, 2022 at 02:17:19PM -0800, Fan Wu wrote:
> We have also noticed many use cases for the fs-verity build-in signatures. Proposals
> exist to use them[1]. Package managers were updated to use them[2]. We are
> successfully using them in production. Therefore we prefer to keep the existing
> build-in signatures.
> 
> [1]https://fedoraproject.org/wiki/Changes/FsVerityRPM#Enable_fs-verity_in_RPM
> [2]https://github.com/rpm-software-management/rpm/issues/1121

Aren't those the same project?  I already mentioned in the commit message that
it was rejected from Fedora and seems to have been abandoned.  So it seems to be
something that didn't actually work out.  Let me know if you know of anything to
the contrary...

- Eric
