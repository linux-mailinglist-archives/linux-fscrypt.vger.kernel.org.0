Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A872A606B2B
	for <lists+linux-fscrypt@lfdr.de>; Fri, 21 Oct 2022 00:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiJTWUq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Oct 2022 18:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbiJTWUp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Oct 2022 18:20:45 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16750103274;
        Thu, 20 Oct 2022 15:20:44 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 5634D808ED;
        Thu, 20 Oct 2022 18:20:43 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1666304444; bh=nPh27iF9wSd/LGrs7TXL6eJwDrAI/N/QBWb8wzTYmE4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Wf4TlVkW1Z2AuKECnrXW1kVkpGZdtosu+ozYnlwEAG4DGIdbuYtgyTBIL1kX0H0pH
         OZho235YtUzfFhGdMqBVttlNgPxNFD7CzgKfoAhEw3lOzIiBEp2JUorLUA410Z8SJJ
         bc2COyCr7+0SJd4weGqUSQJAkWtIe8QdCAuOsQe8pYys6cP2D9ucGSeewiTDeptJE7
         8D5n/sps41IaaAb7g5IIp+YO5Va+b3HAV2yFFWiCFbuwmCvwgaSl3jJ5jBN5eF1VbC
         bw4shkQzaoFLBMC75mXzZewFYntmUxP5xcm2Kp9Z89Tenc21gfPDIrX6hsGrkJvEoH
         UpJifFCA1/I5Q==
Message-ID: <59e243ce-87bb-6ad0-9d76-c87c1b8be6c5@dorminy.me>
Date:   Thu, 20 Oct 2022 18:20:42 -0400
MIME-Version: 1.0
Subject: Re: [PATCH v3 04/22] fscrypt: add extent-based encryption
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
References: <cover.1666281276.git.sweettea-kernel@dorminy.me>
 <d7246959ee0b8d2eeb7d6eb8cf40240374c6035c.1666281277.git.sweettea-kernel@dorminy.me>
 <Y1HAVm8F3U/b+Ic2@sol.localdomain>
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <Y1HAVm8F3U/b+Ic2@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 10/20/22 17:40, Eric Biggers wrote:
> On Thu, Oct 20, 2022 at 12:58:23PM -0400, Sweet Tea Dorminy wrote:
>> +
>> +/*
>> + * fscrypt_extent_context - the encryption context for an extent
>> + *
>> + * For filesystems that support extent encryption, this context provides the
>> + * necessary randomly-initialized IV in order to encrypt/decrypt the data
>> + * stored in the extent. It is stored alongside each extent, and is
>> + * insufficient to decrypt the extent: the extent's owning inode(s) provide the
>> + * policy information (including key identifier) necessary to decrypt.
>> + */
>> +struct fscrypt_extent_context_v1 {
>> +	u8 version;
>> +	union fscrypt_iv iv;
>> +} __packed;
> 
> On the previous version I had suggested using a 16-byte nonce per extent, so
> that it's the same as the inode-based case.  Is there a reason you didn't do
> that?
> 
> - Eric

I probably misunderstood what you meant. For the direct-key case, the 
initial extent context is generated by copying the inode's nonce (and 
setting the lblk_num field to match the starting lblk of the extent, for 
all the policies). In theory, this should result in the same IVs being 
used for unshared extents as would have happened for inode-based encryption?
