Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E24741AC0A
	for <lists+linux-fscrypt@lfdr.de>; Sun, 12 May 2019 14:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfELM1N (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 12 May 2019 08:27:13 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43243 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfELM1N (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 12 May 2019 08:27:13 -0400
Received: by mail-pl1-f194.google.com with SMTP id n8so5012823plp.10;
        Sun, 12 May 2019 05:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=58HCYVRTqobqUo2ksnPAWB/ngXCdwdmeOb+rMbYI3rs=;
        b=vhqiobzi0QEfdN26esKTCVvUOrfmRVA9Jdrv12jnA0bmL7SpumIrk5Ev6poIXE5R4a
         aAF0EP7PdJO4EnNa7dknyuSSGw++Xk7DDiSPrwYpxdgyeg0aD6rhwFuBj7yH7bb0EoLh
         xdspnZUij+jHdx21FTrbYdU4UMFlkuVa7cM0MvL1HhkjsOe32RxW5X0rNahuAksHtOra
         vuwnSmC9mOxX0cWLE20LFJlISVc8c1xw7yf5TtjGnAT0VFU81qK2QUq1tCYEjyXEztCV
         X6ZBY5R5EKZPeuiJArfpakcjbUhBVPB04ot7Vlz8QQiMMhTONTjMoYtoxKCzywv6lkRN
         U45A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=58HCYVRTqobqUo2ksnPAWB/ngXCdwdmeOb+rMbYI3rs=;
        b=rftOiXqLDqJel4AewFvzrdSo1HyPI7dwnS7tXxVbo440fZwTJ0oOQOYN3KFUnFjqkk
         7M2r21JWrigaIty4h8/JKoQVQXaVoMbqT0xMFfRVgONRRFIe3eduVl7M5t6MnFM4HUzF
         3dDb/gZrLxpKYoaY+0fEf6b2aCGj0ENPtKc/RgNuW4fAUNTOKRtUUfGPUQdcD5DUZuDI
         Nc+pNbjmQ3P+2PpA40FODHY8Mft3fjDGGAMk/Urap3/T5A3zoR44q2lgXtYQWl1kNr/e
         xNQwB3r3I77s06Xmc9zJUmpqWtXsnSvNIDzZPeyx8bsZ6vAcUIl8jyS8NK35/Mb4W0+C
         OmLw==
X-Gm-Message-State: APjAAAVUIZb25jKMwwWJTXnc9KrbErE+cGPeuthDW8GyM1HpHk1N2ktc
        Q01VPJQhgAVzX2Y3+c+UNfM=
X-Google-Smtp-Source: APXvYqz1VbCAO0wLjCeeDHLoTq7fvKpRainEguVsZknTCXaBEDW092aDqxamek+TYFmHB1NMBbzrhQ==
X-Received: by 2002:a17:902:868e:: with SMTP id g14mr25470158plo.183.1557664031845;
        Sun, 12 May 2019 05:27:11 -0700 (PDT)
Received: from localhost ([128.199.137.77])
        by smtp.gmail.com with ESMTPSA id z7sm12745557pgh.81.2019.05.12.05.27.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 12 May 2019 05:27:10 -0700 (PDT)
Date:   Sun, 12 May 2019 20:27:03 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [RFC PATCH 4/7] common/encrypt: add helper for ciphertext
 verification tests
Message-ID: <20190512122703.GJ15846@desktop>
References: <20190426204153.101861-1-ebiggers@kernel.org>
 <20190426204153.101861-5-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190426204153.101861-5-ebiggers@kernel.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Apr 26, 2019 at 01:41:50PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Introduce a function _verify_ciphertext_for_encryption_policy() which
> verifies the correctness of encryption with the specified settings.
> 
> Basically, it does the following:
> 
> 1. If missing any prerequisites, skip the test.
> 
> 2. Create files in encrypted directories on the scratch device.
> 
> 3. Unmount the scratch device and compare the actual ciphertext stored
>    on-disk to the ciphertext computed by the fscrypt-crypt-util program.
> 
> Both file contents and names are verified, and non-default encryption
> modes are supported.  Previously, non-default encryption modes were
> untested by xfstests.  Also, while there's an existing test generic/399
> that checks that encrypted contents seem random, it doesn't actually
> test for correctness, nor does it test filenames encryption.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  common/encrypt | 390 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 390 insertions(+)
> 
> diff --git a/common/encrypt b/common/encrypt
> index 37f16b94..3e48abc0 100644
> --- a/common/encrypt
> +++ b/common/encrypt
> @@ -263,3 +263,393 @@ _get_encpolicy()
>  
>  	$XFS_IO_PROG -c "get_encpolicy $*" "$file"
>  }
> +
> +# Retrieve the encryption nonce of the given inode as a hex string.  The nonce
> +# was randomly generated by the filesystem and isn't exposed directly to
> +# userspace.  But it can be read using the filesystem's debugging tools.
> +_get_encryption_nonce()
> +{
> +	local device=$1
> +	local inode=$2
> +
> +	case $FSTYP in
> +	ext4)
> +		# Use debugfs to dump the special xattr named "c", which is the
> +		# file's fscrypt_context.  This produces a line like:
> +		#
> +		#	c (28) = 01 01 04 02 00 00 00 00 00 00 00 00 ef bd 18 76 5d f6 41 4e c0 a2 cd 5f 91 29 7e 12
> +		#
> +		# Then filter it to get just the 16-byte 'nonce' field at the end:
> +		#
> +		#	efbd18765df6414ec0a2cd5f91297e12
> +		#
> +		$DEBUGFS_PROG $device -R "ea_get <$inode> c" 2>>$seqres.full \
> +			| grep '^c' | sed 's/^.*=//' | tr -d ' \n' | tail -c 32
> +		;;
> +	f2fs)
> +		# dump.f2fs prints the fscrypt_context like:
> +		#
> +		#	xattr: e_name_index:9 e_name:c e_name_len:1 e_value_size:28 e_value:
> +		#	format: 1
> +		#	contents_encryption_mode: 0x1
> +		#	filenames_encryption_mode: 0x4
> +		#	flags: 0x2
> +		#	master_key_descriptor: 0000000000000000
> +		#	nonce: EFBD18765DF6414EC0A2CD5F91297E12
> +		$DUMP_F2FS_PROG -i $inode $device | awk '
> +			/\<e_name:c\>/ { found = 1 }
> +			/^nonce:/ && found {
> +				print substr($0, length($0) - 31, 32);
> +				found = 0;
> +			}'
> +		;;
> +	*)
> +		_notrun "_get_encryption_nonce() isn't implemented on $FSTYP"
> +		;;

No need to _notrun here, _require_get_encryption_nonce_support() should
be called first and already does the check in test. Perhaps just echoing
an error message to indicate the failure here is fine.

> +	esac
> +}
> +
> +# Require support for _get_encryption_nonce()
> +_require_get_encryption_nonce_support()
> +{
> +	echo "Checking for _get_encryption_nonce() support for $FSTYP" >> $seqres.full
> +	case $FSTYP in
> +	ext4)
> +		_require_command "$DEBUGFS_PROG" debugfs
> +		;;
> +	f2fs)
> +		_require_command "$DUMP_F2FS_PROG" dump.f2fs
> +		;;
> +	*)
> +		_notrun "_get_encryption_nonce() isn't implemented on $FSTYP"
> +		;;
> +	esac
> +}
> +
> +# Retrieve the filename stored on-disk for the given file.
> +# The name is printed to stdout in binary.
> +_get_on_disk_filename()
> +{
> +	local device=$1
> +	local inode=$2
> +	local dir_inode=$3
> +
> +	case $FSTYP in
> +	ext4)
> +		# Extract the filename from the debugfs output line like:
> +		#
> +		#  131075  100644 (1)      0      0       0 22-Apr-2019 16:54 \xa2\x85\xb0z\x13\xe9\x09\x86R\xed\xdc\xce\xad\x14d\x19
> +		#
> +		$DEBUGFS_PROG $device -R "ls -l -r <$dir_inode>" \
> +					2>>$seqres.full | perl -ne '
> +			next if not /^\s*'$inode'\s+/;
> +			s/.*?\d\d:\d\d //;
> +			chomp;
> +			s/\\x([[:xdigit:]]{2})/chr hex $1/eg;
> +			print;'
> +		;;
> +	f2fs)
> +		# Extract the filename from the dump.f2fs output line like:
> +		#
> +		#  i_name                        		[UpkzIPuts9by1oDmE+Ivfw]
> +		#
> +		# The name is base64-encoded, so we have to decode it here.
> +		#
> +		$DUMP_F2FS_PROG $device -i $inode | perl -ne '
> +			next if not /^i_name\s+\[([A-Za-z0-9+,]+)\]/;
> +			chomp $1;
> +			my @chars = split //, $1;
> +			my $ac = 0;
> +			my $bits = 0;
> +			my $table = join "", (A..Z, a..z, 0..9, "+", ",");
> +			foreach (@chars) {
> +				$ac += index($table, $_) << $bits;
> +				$bits += 6;
> +				if ($bits >= 8) {
> +					print chr($ac & 0xff);
> +					$ac >>= 8;
> +					$bits -= 8;
> +				}
> +			}
> +			if ($ac != 0) {
> +				print STDERR "Invalid base64-encoded string!\n";
> +			}'
> +		;;
> +	*)
> +		_notrun "_get_on_disk_filename() isn't implemented on $FSTYP"

Same here, the get_on_disk_filename support is checked by
_require_get_on_disk_filename_support(). And looks like this function
has nothing to do with fs encryption, move it to common/rc?

> +		;;
> +	esac
> +}
> +
> +# Require support for _get_on_disk_filename()
> +_require_get_on_disk_filename_support()
> +{
> +	echo "Checking for _get_on_disk_filename() support for $FSTYP" >> $seqres.full
> +	case $FSTYP in
> +	ext4)
> +		# Verify that the "ls -l -r" debugfs command is supported and
> +		# hex-encodes non-ASCII characters, rather than using an
> +		# ambiguous escaping method.  This requires the e2fsprogs patch
> +		# "debugfs: avoid ambiguity when printing filenames"
> +		# (https://marc.info/?l=linux-ext4&m=155596495624232&w=2).
> +		# TODO: once merged, list the minimum e2fsprogs version here.
> +		_require_command "$DEBUGFS_PROG" debugfs
> +		_scratch_mount
> +		touch $SCRATCH_MNT/$'\xc1'
> +		_scratch_unmount
> +		if ! $DEBUGFS_PROG $SCRATCH_DEV -R "ls -l -r /" 2>&1 \
> +			| tee -a $seqres.full | grep -E -q '\s+\\xc1\s*$'; then
> +			_notrun "debugfs (e2fsprogs) is too old; doesn't support showing unambiguous on-disk filenames"
> +		fi
> +		;;
> +	f2fs)
> +		# Verify that dump.f2fs shows encrypted filenames in full.  This
> +		# requires the patch "f2fs-tools: improve filename printing"
> +		# (https://sourceforge.net/p/linux-f2fs/mailman/message/36648641/).
> +		# TODO: once merged, list the minimum f2fs-tools version here.
> +
> +		_require_command "$DUMP_F2FS_PROG" dump.f2fs
> +		_require_command "$KEYCTL_PROG" keyctl
> +		_scratch_mount
> +		_new_session_keyring
> +
> +		local keydesc=$(_generate_encryption_key)
> +		local dir=$SCRATCH_MNT/test.${FUNCNAME[0]}
> +		local file=$dir/$(perl -e 'print "A" x 255')
> +		mkdir $dir
> +		_set_encpolicy $dir $keydesc
> +		touch $file
> +		local inode=$(stat -c %i $file)
> +
> +		_scratch_unmount
> +		$KEYCTL_PROG clear @s
> +
> +		# 255-character filename should result in 340 base64 characters.
> +		if ! $DUMP_F2FS_PROG -i $inode $SCRATCH_DEV \
> +			| grep -E -q '^i_name[[:space:]]+\[[A-Za-z0-9+,]{340}\]'; then
> +			_notrun "dump.f2fs (f2fs-tools) is too old; doesn't support showing unambiguous on-disk filenames"
> +		fi
> +		;;
> +	*)
> +		_notrun "_get_on_disk_filename() isn't implemented on $FSTYP"
> +		;;
> +	esac
> +}
> +
> +# Get the file's list of on-disk blocks as a comma-separated list of block
> +# offsets from the start of the device.  "Blocks" are 512 bytes each here.
> +_get_file_block_list()
> +{
> +	local file=$1
> +
> +	sync
> +	$XFS_IO_PROG -c fiemap $file | perl -ne '
> +		next if not /^\s*\d+: \[\d+\.\.\d+\]: (\d+)\.\.(\d+)/;
> +		print $_ . "," foreach $1..$2;' | sed 's/,$//'
> +}
> +
> +# Dump a block list that was previously saved by _get_file_block_list().
> +_dump_file_blocks()
> +{
> +	local device=$1
> +	local blocklist=$2
> +	local block
> +
> +	for block in $(tr ',' ' ' <<< $blocklist); do
> +		dd if=$device bs=512 count=1 skip=$block status=none
> +	done
> +}

Above two functions seem generic enough to be moved to common/rc

Thanks,
Eryu

> +
> +_do_verify_ciphertext_for_encryption_policy()
> +{
> +	local contents_encryption_mode=$1
> +	local filenames_encryption_mode=$2
> +	local policy_flags=$3
> +	local set_encpolicy_args=$4
> +	local keydesc=$5
> +	local raw_key_hex=$6
> +	local crypt_cmd="src/fscrypt-crypt-util $7"
> +
> +	local blocksize=$(_get_block_size $SCRATCH_MNT)
> +	local test_contents_files=()
> +	local test_filenames_files=()
> +	local i src dir dst inode blocklist \
> +	      padding_flag padding dir_inode len name f nonce decrypted_name
> +
> +	# Create files whose encrypted contents we'll verify.  For each, save
> +	# the information: (copy of original file, inode number of encrypted
> +	# file, comma-separated block list) into test_contents_files[].
> +	echo "Creating files for contents verification" >> $seqres.full
> +	i=1
> +	rm -f $tmp.testfile_*
> +	for src in /dev/zero /dev/urandom; do
> +		head -c $((4 * blocksize)) $src > $tmp.testfile_$i
> +		(( i++ ))
> +	done
> +	dir=$SCRATCH_MNT/encdir
> +	mkdir $dir
> +	_set_encpolicy $dir $keydesc $set_encpolicy_args -f $policy_flags
> +	for src in $tmp.testfile_*; do
> +		dst=$dir/${src##*.}
> +		cp $src $dst
> +		inode=$(stat -c %i $dst)
> +		blocklist=$(_get_file_block_list $dst)
> +		test_contents_files+=("$src $inode $blocklist")
> +	done
> +
> +	# Create files whose encrypted names we'll verify.  For each, save the
> +	# information: (original filename, inode number of encrypted file, inode
> +	# of parent directory, padding amount) into test_filenames_files[].  Try
> +	# each padding amount: 4, 8, 16, or 32 bytes.  Also try various filename
> +	# lengths, including boundary cases.  Assume NAME_MAX == 255.
> +	echo "Creating files for filenames verification" >> $seqres.full
> +	for padding_flag in 0 1 2 3; do
> +		padding=$((4 << padding_flag))
> +		dir=$SCRATCH_MNT/encdir.pad$padding
> +		mkdir $dir
> +		dir_inode=$(stat -c %i $dir)
> +		_set_encpolicy $dir $keydesc $set_encpolicy_args \
> +			-f $((policy_flags | padding_flag))
> +		for len in 1 3 15 16 17 32 100 254 255; do
> +			name=$(tr -d -C a-zA-Z0-9 < /dev/urandom | head -c $len)
> +			touch $dir/$name
> +			inode=$(stat -c %i $dir/$name)
> +			test_filenames_files+=("$name $inode $dir_inode $padding")
> +		done
> +	done
> +
> +	# Now unmount the filesystem and verify the ciphertext we just wrote.
> +	_scratch_unmount
> +
> +	echo "Verifying encrypted file contents" >> $seqres.full
> +	for f in "${test_contents_files[@]}"; do
> +		read -r src inode blocklist <<< "$f"
> +		nonce=$(_get_encryption_nonce $SCRATCH_DEV $inode)
> +		_dump_file_blocks $SCRATCH_DEV $blocklist > $tmp.actual_contents
> +		$crypt_cmd $contents_encryption_mode $raw_key_hex \
> +			--file-nonce=$nonce --block-size=$blocksize \
> +			< $src > $tmp.expected_contents
> +		if ! cmp $tmp.expected_contents $tmp.actual_contents; then
> +			_fail "Expected encrypted contents != actual encrypted contents.  File: $f"
> +		fi
> +		$crypt_cmd $contents_encryption_mode $raw_key_hex --decrypt \
> +			--file-nonce=$nonce --block-size=$blocksize \
> +			< $tmp.actual_contents > $tmp.decrypted_contents
> +		if ! cmp $src $tmp.decrypted_contents; then
> +			_fail "Contents decryption sanity check failed.  File: $f"
> +		fi
> +	done
> +
> +	echo "Verifying encrypted file names" >> $seqres.full
> +	for f in "${test_filenames_files[@]}"; do
> +		read -r name inode dir_inode padding <<< "$f"
> +		nonce=$(_get_encryption_nonce $SCRATCH_DEV $dir_inode)
> +		_get_on_disk_filename $SCRATCH_DEV $inode $dir_inode \
> +			> $tmp.actual_name
> +		echo -n "$name" | \
> +			$crypt_cmd $filenames_encryption_mode $raw_key_hex \
> +			--file-nonce=$nonce --padding=$padding \
> +			--block-size=255 > $tmp.expected_name
> +		if ! cmp $tmp.expected_name $tmp.actual_name; then
> +			_fail "Expected encrypted filename != actual encrypted filename.  File: $f"
> +		fi
> +		$crypt_cmd $filenames_encryption_mode $raw_key_hex --decrypt \
> +			--file-nonce=$nonce --padding=$padding \
> +			--block-size=255 < $tmp.actual_name \
> +			> $tmp.decrypted_name
> +		decrypted_name=$(tr -d '\0' < $tmp.decrypted_name)
> +		if [ "$name" != "$decrypted_name" ]; then
> +			_fail "Filename decryption sanity check failed ($name != $decrypted_name).  File: $f"
> +		fi
> +	done
> +}
> +
> +_fscrypt_mode_name_to_num()
> +{
> +	local name=$1
> +
> +	case "$name" in
> +	AES-256-XTS)		echo 1 ;; # FS_ENCRYPTION_MODE_AES_256_XTS
> +	AES-256-CTS-CBC)	echo 4 ;; # FS_ENCRYPTION_MODE_AES_256_CTS
> +	AES-128-CBC-ESSIV)	echo 5 ;; # FS_ENCRYPTION_MODE_AES_128_CBC
> +	AES-128-CTS-CBC)	echo 6 ;; # FS_ENCRYPTION_MODE_AES_128_CTS
> +	Adiantum)		echo 9 ;; # FS_ENCRYPTION_MODE_ADIANTUM
> +	*)			_fail "Unknown fscrypt mode: $name" ;;
> +	esac
> +}
> +
> +# Verify that file contents and names are encrypted correctly when an encryption
> +# policy of the specified type is used.
> +#
> +# The first two parameters are the contents and filenames encryption modes to
> +# test.  Optionally, also specify 'direct' to test the DIRECT_KEY flag.
> +_verify_ciphertext_for_encryption_policy()
> +{
> +	local contents_encryption_mode=$1
> +	local filenames_encryption_mode=$2
> +	local opt
> +	local policy_flags=0
> +	local set_encpolicy_args=""
> +	local crypt_util_args=""
> +
> +	shift 2
> +	for opt; do
> +		case "$opt" in
> +		direct)
> +			if [ $contents_encryption_mode != \
> +			     $filenames_encryption_mode ]; then
> +				_fail "For direct key mode, contents and filenames modes must match"
> +			fi
> +			(( policy_flags |= 0x04 )) # FS_POLICY_FLAG_DIRECT_KEY
> +			;;
> +		*)
> +			_fail "Unknown option '$opt' passed to ${FUNCNAME[0]}"
> +			;;
> +		esac
> +	done
> +	local contents_mode_num=$(_fscrypt_mode_name_to_num $contents_encryption_mode)
> +	local filenames_mode_num=$(_fscrypt_mode_name_to_num $filenames_encryption_mode)
> +
> +	set_encpolicy_args+=" -c $contents_mode_num"
> +	set_encpolicy_args+=" -n $filenames_mode_num"
> +
> +	if (( policy_flags & 0x04 )); then
> +		crypt_util_args+=" --kdf=none"
> +	else
> +		crypt_util_args+=" --kdf=AES-128-ECB"
> +	fi
> +	set_encpolicy_args=${set_encpolicy_args# }
> +
> +	_require_scratch_encryption $set_encpolicy_args
> +	_require_test_program "fscrypt-crypt-util"
> +	_require_xfs_io_command "fiemap"
> +	_require_get_encryption_nonce_support
> +	_require_get_on_disk_filename_support
> +	_require_command "$KEYCTL_PROG" keyctl
> +
> +	echo "Creating encryption-capable filesystem" >> $seqres.full
> +	_scratch_mkfs_encrypted &>> $seqres.full
> +	_scratch_mount
> +
> +	echo "Generating encryption key" >> $seqres.full
> +	local raw_key=$(_generate_raw_encryption_key)
> +	local keydesc=$(_generate_key_descriptor)
> +	_new_session_keyring
> +	_add_encryption_key $keydesc $raw_key
> +	local raw_key_hex=$(echo "$raw_key" | tr -d '\\x')
> +
> +	echo
> +	echo -e "Verifying ciphertext with parameters:"
> +	echo -e "\tcontents_encryption_mode: $contents_encryption_mode"
> +	echo -e "\tfilenames_encryption_mode: $filenames_encryption_mode"
> +	[ $# -ne 0 ] && echo -e "\toptions: $*"
> +
> +	_do_verify_ciphertext_for_encryption_policy \
> +		"$contents_encryption_mode" \
> +		"$filenames_encryption_mode" \
> +		"$policy_flags" \
> +		"$set_encpolicy_args" \
> +		"$keydesc" \
> +		"$raw_key_hex" \
> +		"$crypt_util_args"
> +}
> -- 
> 2.21.0.593.g511ec345e18-goog
> 
