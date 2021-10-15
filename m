Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C50FB42FC08
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 Oct 2021 21:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242725AbhJOT2J (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 15 Oct 2021 15:28:09 -0400
Received: from linux.microsoft.com ([13.77.154.182]:52008 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242723AbhJOT2B (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 15 Oct 2021 15:28:01 -0400
Received: from [10.137.106.139] (unknown [131.107.159.11])
        by linux.microsoft.com (Postfix) with ESMTPSA id 217B720B9D2B;
        Fri, 15 Oct 2021 12:25:53 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 217B720B9D2B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634325953;
        bh=lQmgAQ2ux0khJOaT354qBFfxeuC7/g4/rZr1otAkgC4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=SeGCQJZGDEBOlAWSP8SrWSrbF3OxA6pk6Bix/M/DHXZgr9aI33izBdGGXamrmijaS
         k2sjBkyLvFzajpvdxtMWfkAoGjI2jQcYEkGiDlIE+JEnF+7cai5oGWtR+OFQdQKfzQ
         QKFYnqu90ONiC7L/6YGYJFJdT8uO8zOe5aCEdBSs=
Message-ID: <9089bdb0-b28a-9fa0-c510-00fa275af621@linux.microsoft.com>
Date:   Fri, 15 Oct 2021 12:25:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH v7 12/16] fsverity|security: add security hooks to
 fsverity digest and signature
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     corbet@lwn.net, axboe@kernel.dk, agk@redhat.com,
        snitzer@redhat.com, tytso@mit.edu, paul@paul-moore.com,
        eparis@redhat.com, jmorris@namei.org, serge@hallyn.com,
        jannh@google.com, dm-devel@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-audit@redhat.com,
        linux-security-module@vger.kernel.org
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
 <1634151995-16266-13-git-send-email-deven.desai@linux.microsoft.com>
 <YWcyYBuNppjrVOe2@gmail.com>
From:   Deven Bowers <deven.desai@linux.microsoft.com>
In-Reply-To: <YWcyYBuNppjrVOe2@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


On 10/13/2021 12:24 PM, Eric Biggers wrote:
> On Wed, Oct 13, 2021 at 12:06:31PM -0700, deven.desai@linux.microsoft.com wrote:
>> From: Fan Wu <wufan@linux.microsoft.com>
>>
>> Add security_inode_setsecurity to fsverity signature verification.
>> This can let LSMs save the signature data and digest hashes provided
>> by fsverity.
> Can you elaborate on why LSMs need this information?

The proposed LSM (IPE) of this series will be the only one to need
this information at the  moment. IPE’s goal is to have provide
trust-based access control. Trust and Integrity are tied together,
as you cannot prove trust without proving integrity.

IPE needs the digest information to be able to compare a digest
provided by the policy author, against the digest calculated by
fsverity to make a decision on whether that specific file, represented
by the digest is authorized for the actions specified in the policy.

A more concrete example, if an IPE policy author writes:

     op=EXECUTE fsverity_digest=<HexDigest > action=DENY

IPE takes the digest provided by this security hook, stores it
in IPE's security blob on the inode. If this file is later
executed, IPE compares the digest stored in the LSM blob,
provided by this hook, against <HexDigest> in the policy, if
it matches, it denies the access, performing a revocation
of that file.

This brings me to your next comment:

 > The digest isn't meaningful without knowing the hash algorithm it uses.
It's available here, but you aren't passing it to this function.

The digest is meaningful without the algorithm in this case.
IPE does not want to recalculate a digest, that’s expensive and
doesn’t provide any value. IPE, in this case, treats this as a
buffer to compare the policy-provided one above to make a
policy decision about access to the resource.

>> Also changes the implementaion inside the hook function to let
>> multiple LSMs can add hooks.
> Please split fs/verity/ changes and security/ changes into separate patches, if
> possible.

Sorry, will do, not a problem.

>> @@ -177,6 +178,17 @@ struct fsverity_info *fsverity_create_info(const struct inode *inode,
>>   		fsverity_err(inode, "Error %d computing file digest", err);
>>   		goto out;
>>   	}
>> +
>> +	err = security_inode_setsecurity((struct inode *)inode,
> If a non-const inode is needed, please propagate that into the callers rather
> than randomly casting away the const.
>
>> +					 FS_VERITY_DIGEST_SEC_NAME,
>> +					 vi->file_digest,
>> +					 vi->tree_params.hash_alg->digest_size,
>> +					 0);
>> @@ -84,7 +85,9 @@ int fsverity_verify_signature(const struct fsverity_info *vi,
>>   
>>   	pr_debug("Valid signature for file digest %s:%*phN\n",
>>   		 hash_alg->name, hash_alg->digest_size, vi->file_digest);
>> -	return 0;
>> +	return security_inode_setsecurity((struct inode *)inode,
>>
> Likewise, please don't cast away const.

Sorry, I should've caught these myself. I'll change
fsverity_create_info to accept the non-const inode, and
change fsverity_verify_signature to accept an additional inode
struct as the first arg instead of changing the fsverity_info
structure to have a non-const inode field.

>> +					FS_VERITY_SIGNATURE_SEC_NAME,
>> +					signature, sig_size, 0);
> This is only for fs-verity built-in signatures which aren't the only way to do
> signatures with fs-verity.  Are you sure this is what you're looking for?

Could you elaborate on the other signature types that can be used
with fs-verity? I’m 99% sure this is what I’m looking for as this
is a signature validated in the kernel against the fs-verity keyring
as part of the “fsverity enable” utility.

It's important that the signature is validated in the kernel, as
userspace is considered untrusted until the signature is validated
for this case.

> Can you elaborate on your use case for fs-verity built-in signatures,
Sure, signatures, like digests, also provide a way to prove integrity,
and the trust component comes from the validation against the keyring,
as opposed to a fixed value in IPE’s policy. The use case for fs-verity
built-in signatures is that we have a rw ext4 filesystem that has some
executable files, and we want to have a execution policy (through IPE)
that only _trusted_ executables can run. Perf is important here, hence
fs-verity.

> and what the LSM hook will do with them?

At the moment, this will just signal to IPE that these fs-verity files were
enabled with a built-in signature as opposed to enabled without a signature.
In v7, it copies the signature data into IPE's LSM blob attached to the 
inode.
In v8+, I'm changing this to store “true” in IPE's LSM blob instead, as 
copying
the signature data is an unnecessary waste of space and point of 
failure. This
has a _slightly_ different functionality then fs.verity.require_signatures,
because even if someone were to disable the require signatures option, IPE
would still know if these files were signed or not and be able to make the
access control decision based IPE's policy.

Very concretely, this powers this kind of rule in IPE:

   op=EXECUTE fsverity_signature=TRUE action=ALLOW

if that fsverity_signature value in IPE’s LSM blob attached to the inode is
true, then fsverity_signature in IPE’s policy will evaluate to true and 
match
this rule. The inverse is also applicable.

