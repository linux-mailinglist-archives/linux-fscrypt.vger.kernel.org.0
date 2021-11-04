Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E04A445813
	for <lists+linux-fscrypt@lfdr.de>; Thu,  4 Nov 2021 18:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbhKDROv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 4 Nov 2021 13:14:51 -0400
Received: from linux.microsoft.com ([13.77.154.182]:55138 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232614AbhKDROt (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 4 Nov 2021 13:14:49 -0400
Received: from [10.137.106.139] (unknown [131.107.159.11])
        by linux.microsoft.com (Postfix) with ESMTPSA id 5ED1720ABA94;
        Thu,  4 Nov 2021 10:12:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5ED1720ABA94
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1636045930;
        bh=qEPw2InKnsvskNfMVAs79ETCgoEtkA0LqlU3T/wm4UU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=TOKjsjpHy/6jP6DASOEiio4+SFbY1bV2zRvkMssy96xZM0i5VxP1rkA4e/T9SCZ6P
         4waObN9FPi2nFKpG56+iXnUxO+7Q+NmeIx/NfccfBZOI2tCSlSsiK5C+0559jeIH7u
         f+DR+oor43nyIe7u/bOblKF60y+83HkhuOSbu32Q=
Message-ID: <8d12dcf4-165d-9db6-5a42-591bc8b97c00@linux.microsoft.com>
Date:   Thu, 4 Nov 2021 10:12:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [RFC PATCH v7 12/16] fsverity|security: add security hooks to
 fsverity digest and signature
Content-Language: en-US
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     "corbet@lwn.net" <corbet@lwn.net>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "agk@redhat.com" <agk@redhat.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "paul@paul-moore.com" <paul@paul-moore.com>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "jannh@google.com" <jannh@google.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
 <1634151995-16266-13-git-send-email-deven.desai@linux.microsoft.com>
 <YWcyYBuNppjrVOe2@gmail.com>
 <9089bdb0-b28a-9fa0-c510-00fa275af621@linux.microsoft.com>
 <0b4c9a91afb441b085ec914118617ee7@huawei.com>
From:   Deven Bowers <deven.desai@linux.microsoft.com>
In-Reply-To: <0b4c9a91afb441b085ec914118617ee7@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


On 11/3/2021 5:28 AM, Roberto Sassu wrote:
>> From: Deven Bowers [mailto:deven.desai@linux.microsoft.com]
>> Sent: Friday, October 15, 2021 9:26 PM
>> On 10/13/2021 12:24 PM, Eric Biggers wrote:
>>> On Wed, Oct 13, 2021 at 12:06:31PM -0700,
>> deven.desai@linux.microsoft.com wrote:
>>>> From: Fan Wu <wufan@linux.microsoft.com>
>>>>
>>>> Add security_inode_setsecurity to fsverity signature verification.
>>>> This can let LSMs save the signature data and digest hashes provided
>>>> by fsverity.
>>> Can you elaborate on why LSMs need this information?
>> The proposed LSM (IPE) of this series will be the only one to need
>> this information at the  moment. IPE’s goal is to have provide
>> trust-based access control. Trust and Integrity are tied together,
>> as you cannot prove trust without proving integrity.
> I wanted to go back on this question.
>
> It seems, at least for fsverity, that you could obtain the
> root digest at run-time, without storing it in a security blob.
>
> I thought I should use fsverity_get_info() but the fsverity_info
> structure is not exported (it is defined in fs/verity/fsverity_private.h).
>
> Then, I defined a new function, fsverity_get_file_digest() to copy
> the file_digest member of fsverity_info to a buffer and to pass
> the associated hash algorithm.
>
> With that, the code of evaluate() for DIGLIM becomes:
>
>          info = fsverity_get_info(file_inode(ctx->file));
>          if (info)
>                  ret = fsverity_get_file_digest(info, buffer, sizeof(buffer), &algo);
>
>          if (!strcmp(expect->data, "diglim") && ret > 0) {
>                  ret = diglim_digest_get_info(buffer, algo, COMPACT_FILE, &modifiers, &actions);
>                  if (!ret)
>                          return true;
>          }
This would work with the digest with a bit more code in fs-verity. It
also has benefits if there are other callers who want this information.

I was planning on grouping the digest and signature into 
apublic_key_signature
structure in v8 to pass the digest, digest algorithm,digest size, signature
and signature size (as opposed to defining a new structfor this purpose),
reducing the number of LSM hook calls down to one functionin fsverity.

I think both approaches have merit. fsverity_get_file_digest is more useful
if there are callers outside of LSMs that want this information. The LSM 
hook
is cleaner if only LSMs want this information.

At least, at the moment, it seems like it's only IPE who wants this 
information,
and it's not like it won't be able to change later if the need arises, 
as this
is all implementation details that wouldn't effect the end-user.

I'll defer to Eric - his opinion holds the most weight, as fsverity would be
the main code affected in either case.

