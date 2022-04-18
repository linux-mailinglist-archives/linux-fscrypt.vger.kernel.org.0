Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF4A505D83
	for <lists+linux-fscrypt@lfdr.de>; Mon, 18 Apr 2022 19:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232964AbiDRRdF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 18 Apr 2022 13:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346786AbiDRRdE (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 18 Apr 2022 13:33:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02CB92E9D2
        for <linux-fscrypt@vger.kernel.org>; Mon, 18 Apr 2022 10:30:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B645CB81053
        for <linux-fscrypt@vger.kernel.org>; Mon, 18 Apr 2022 17:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6684AC385A1;
        Mon, 18 Apr 2022 17:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650303022;
        bh=+UIzYVxyzxRT11X4z3T0x4T8DeFC/oA4RVmksBl+vv0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=onF7uV2GsHodWyQ/+IJQZK8BD7NFbinJLCI6fmiXoZBk9x0TL1qlAZwvsu0w25VTB
         zn/gBFvUDv/kycWk3vLIh2EWGUvnK1yseUqbxhlPW8e0OnRFEMIm3jLokcb1G5dNmR
         MKg52n9V9SPZd/mbPTcdNfqeWBIGsmMxNNV3IJUi1tbeX2z9Ba9tH5vHWErLbZ0k9g
         NzQswJY75XF43FbUAGQ13qkUaiN99kNEaYJ+J30lu1GtwJhQqrhwV5N7Ic4j2RVTpp
         xp/zhtmDM6itNQnvsK9C+6D5WB6ECSwbmAi7qRzugLSsLdkswKeSujtiN4zPebYqPH
         laUvcQYhl9USg==
Date:   Mon, 18 Apr 2022 17:30:20 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     =?utf-8?B?5bi45Yek5qWg?= <changfengnan@vivo.com>
Cc:     "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "chao@kernel.org" <chao@kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-f2fs-devel@lists.sourceforge.net" 
        <linux-f2fs-devel@lists.sourceforge.net>,
        linux-fscrypt@vger.kernel.org
Subject: Re: f2fs compressed file bio merge problem
Message-ID: <Yl2gLG/8U9HdRpUT@gmail.com>
References: <KL1PR0601MB4003AA93745F5F9A79794BE4BBF39@KL1PR0601MB4003.apcprd06.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <KL1PR0601MB4003AA93745F5F9A79794BE4BBF39@KL1PR0601MB4003.apcprd06.prod.outlook.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

[+Cc linux-fscrypt]

On Mon, Apr 18, 2022 at 08:15:47AM +0000, 常凤楠 wrote:
> Hi:
> 	When I test seq-write on f2fs compressed file, I found it may have significant performance degradation when mount with inlinecrypt. Here is my analysis: 	
> 	f2fs write compressed file in unit of cluster, after compressed, one cluster up to have three valid pages to write. So between multi clusters, the page index couldn't be contiguous. For example, It may like this: Cluster 0 write page 0 and 1, Cluster 1 write page 4 and 5.
> 	In f2fs_crypt_mergeable_bio, fscrypt_mergeable_bio will check weather file logical block number is contiguous, result in multi clusters cannot be merge into one bio.
> 	In my test, inlinecrypt mount option may cause seq-write performance to drop by half.
> 	The attachment is my fio test configure file.
> 	This is a tricky problem for me. Is there any solution for this problem?

Thanks for clarifying that you are using f2fs compression; in your previous
message you didn't mention this
(https://lore.kernel.org/all/KL1PR0601MB4003998B841513BCAA386ADEBBEE9@KL1PR0601MB4003.apcprd06.prod.outlook.com/T/#u).

Unfortunately, I don't believe there is any practical way that we could do the
encryption differently that would result in this no longer being a problem.

This is because for adjacent clusters to have contiguous DUNs, the DUNs would
have to increment according to the compressed size, not the uncompressed size.
However, in this case it wouldn't be possible to support random-access writes,
since any write would require re-writing the entire file.

This could be provided as an option for read-only filesystems, I suppose.  But I
doubt that that is your use case.

- Eric
