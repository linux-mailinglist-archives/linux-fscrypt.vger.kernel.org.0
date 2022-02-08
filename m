Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 262EF4ACEC9
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Feb 2022 03:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345690AbiBHCUo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 7 Feb 2022 21:20:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345872AbiBHCUn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 7 Feb 2022 21:20:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A883C061A73;
        Mon,  7 Feb 2022 18:20:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB68D61467;
        Tue,  8 Feb 2022 02:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A8EC004E1;
        Tue,  8 Feb 2022 02:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644286842;
        bh=NLFi2rCztlPLPqtBpWQu8LGPB4klLypkVFQ9xBaOwio=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G1PiBpjnJlU2Ep18UvcZeArW0L8aEnVz92ExEzTDs7uFsXN1so9+OSnRJjeuVfjY7
         fyRHRjWXMaZa5OSseCISDHVc8t0/g482wwxXI0oObNuRsif/oKDgwa6eCf7iw3pnwn
         zy1YGltzVNzSrFulGYykKSeJ3crfzNsOR3XtDKPwiZygqvsahmn+5jAny3zH7QsCAw
         6HaGZjoa7DWE2OMxTItYq8QaizYyrtOr7C9spxyNubTF4BRb7wz6UoftzoJU9JxC8e
         tzMcpTgJ5LYvdF7h7jpVyEPDKZrx6ZG5u0SJAzYekTAiMWZy9uvS3anfqC6iPatqBU
         Qyuj5wYYY8ZKA==
Date:   Mon, 7 Feb 2022 18:20:40 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v5 0/4] tests for btrfs fsverity
Message-ID: <YgHTeMETyYlatbuM@sol.localdomain>
References: <cover.1631558495.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1631558495.git.boris@bur.io>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Sep 13, 2021 at 11:44:33AM -0700, Boris Burkov wrote:
> This patchset provides tests for fsverity support in btrfs.
> 
> It includes modifications for generic tests to pass with btrfs as well
> as new tests.
> 

Hi Boris, there's been no activity on this patchset in a while.  Are you
planning to keep working on it?  I'd like to see it finished so that I can start
including btrfs in the fs-verity testing I do.

- Eric
